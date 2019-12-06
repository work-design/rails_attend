module RailsAttend::Attendance
  extend ActiveSupport::Concern

  included do
    attribute :late_minutes, :integer
    attribute :leave_minutes, :integer
    attribute :overtime_hours, :float
    attribute :attend_hours, :float
    attribute :interval_hours, :float
    attribute :total_hours, :float
    attribute :attend_on, :date
    attribute :start_at, :datetime
    attribute :finish_at, :datetime
    attribute :interval_start_at, :datetime
    attribute :interval_finish_at, :datetime
    attribute :kind, :string
    attribute :absence_minutes, :integer
    attribute :absence_redeeming, :boolean
    attribute :lost_logs, :string, array: true
    attribute :workday, :boolean, default: true
    attribute :processed, :boolean, default: false
    
    belongs_to :member
    belongs_to :interval_absence, class_name: 'Absence', optional: true
    belongs_to :late_absence, class_name: 'Absence', optional: true
    belongs_to :leave_absence, class_name: 'Absence', optional: true
    has_many :attendance_logs, dependent: :nullify
  
    enum kind: {
      belated: 'belated',
      asked_leave: 'asked_leave',
      no_meal: 'no_meal',
      allowance: 'allowance'
    }
  
    validates :attend_on, uniqueness: { scope: :member_id }
    before_save :sync_workday, if: -> { attend_on_changed? }
  end
  
  def compute_time_type(record_at)
    arr = [start_at, interval_start_at, interval_finish_at, finish_at, record_at].compact.uniq
    arr.sort!

    if arr.length < 4
      arr.mjust! 4, nil
    end

    if arr.length == 5
      if arr[1] < self.on_time
        arr.delete_at(1)
      elsif arr[-2] > self.off_time
        arr.delete_at(-2)
      else
        arr.delete_at(2)
      end
    end

    logger.debug "-----> results: #{arr.map(&->(o){ o.to_s }).inspect}"

    result = arr.find_index { |x| x == record_at }

    self.start_at = arr[0]
    self.interval_start_at = arr[1] if arr[1] && arr[1] > self.on_time
    self.interval_finish_at = arr[-2] if arr[-2] && arr[-2] < self.off_time
    self.finish_at = arr[-1]

    if result
      ['start_at', 'interval_start_at', 'interval_finish_at', 'finish_at'].fetch(result)
    else
      nil
    end
  end

  def compute_summary
    if self.finish_at && self.start_at
      self.total_hours = (self.finish_at - self.start_at).div(1800) / 2.0
    else
      return
    end

    late_summary
    leave_summary
    self.absence_minutes = self.late_minutes.to_i + self.leave_minutes.to_i

    interval_summary
    total_leave = self.interval_hours.to_f + (self.absence_minutes / 30.0).ceil / 2.0
    self.attend_hours = 8 - total_leave

    if self.attend_hours < 8 && self.attend_hours > 4
      self.kind = 'belated'
    elsif self.attend_hours < 4
      self.kind = 'no_meal'
    else
      self.kind = 'allowance'
    end

    self.overtime_hours = morning_over + evening_over
    self.processed = true
    self.changes
  end

  def compute_summary!
    self.compute_summary
    self.save
  end

  def start_time
    @start_time ||= start_at.in_time_zone(member.timezone)
  end

  def finish_time
    @finish_time ||= finish_at.in_time_zone(member.timezone)
  end

  def interval_start_time
    @interval_start_time ||= interval_start_at.in_time_zone(member.timezone)
  end

  def interval_finish_time
    @interval_finish_time ||= interval_finish_at.in_time_zone(member.timezone)
  end

  def off_time
    return @off_time if @off_time
    if night_shift
      @off_time = self.attend_on.to_datetime.in_time_zone(member.timezone).change hour: 21
    else
      @off_time = self.member.off_time(self.attend_on)
    end
  end

  def on_time
    return @on_time if @on_time
    if night_shift
      @on_time = self.attend_on.to_datetime.in_time_zone(member.timezone).change hour: 13
    else
      @on_time = self.member.on_time(self.attend_on)
    end
  end

  def night_shift
    return false unless member.department&.night_shift

    self.start_time.hour <= 13 && self.start_time.hour >= 11 && self.finish_time.hour >= 21
  end

  def lunch_time
    return @lunch_time if @lunch_time
    start = self.member.lunch_time[0].change year: attend_on.year, month: attend_on.month, day: attend_on.day
    finish = self.member.lunch_time[1].change year: attend_on.year, month: attend_on.month, day: attend_on.day
    @lunch_time = [start, finish]
  end

  def interval_time
    return @interval_time if @interval_time
    return [] unless interval_start_time && interval_finish_time

    if interval_start_time > lunch_time[0] && interval_start_time < lunch_time[1]
      start = lunch_time[1]
    else
      start = interval_start_time
    end

    if interval_finish_time > lunch_time[0] && interval_finish_time < lunch_time[1] && interval_finish_time > start
      finish = lunch_time[0]
    elsif interval_finish_time > lunch_time[0] && interval_finish_time < lunch_time[1] && interval_finish_time <= start
      finish = lunch_time[1]
    else
      finish = interval_finish_time
    end

    @interval_time = [start, finish]
  end

  def morning_time
    @morning_time ||= on_time - 30.minutes
  end

  def evening_time
    @evening_time ||= off_time + 90.minutes
  end

  def evening_over
    return 0 if self.finish_at.blank? || leave_early?
    if self.finish_time < evening_time
      result = self.finish_time.to_i - off_time.to_i
    else
      result = evening_time.to_i - off_time.to_i
    end

    result.div(1800) / 2.0
  end

  def morning_over
    return 0 if self.start_at.blank? || late?
    if self.start_time < morning_time
      result = on_time.to_i - morning_time.to_i
    else
      result = on_time.to_i - self.start_time.to_i
    end

    result.div(1800) / 2.0
  end

  def late?
    self.start_at && self.start_time > self.on_time
  end

  def late_summary
    return unless self.start_time
    unless late?
      self.late_absence_id = nil
      return if self.late_minutes.blank?
    end

    if self.start_time > self.on_time
      self.late_minutes = ((self.start_time.to_i - on_time.to_i) / 60.0).floor
      _late = Absence.default_where(member_id: self.member_id, 'start_at-lte': start_time, 'finish_at-gte': start_time, 'finish_at-lte': off_time).take
      if _late
        self.late_absence_id = _late.id
      else
        self.late_absence_id = nil
      end
    else
      self.late_minutes = nil
    end
  end

  def leave_early?
    self.finish_at && self.finish_time < self.off_time
  end

  def leave_summary
    return unless self.finish_at
    unless leave_early?
      self.leave_absence_id = nil
      return if self.leave_minutes.blank?
    end

    if self.finish_time < self.off_time
      self.leave_minutes = ((off_time.to_i - self.finish_time.to_i) / 60.0).floor
      _leave = Absence.default_where(member_id: self.member_id, 'start_at-gte': finish_time, 'finish_at-lte': off_time).take
      if _leave
        self.leave_absence_id = _leave.id
      else
        self.leave_absence_id = nil
      end
    else
      self.leave_minutes = nil
    end
  end

  def interval_leave?
    return false unless interval_start_at && interval_finish_at
    !(self.interval_start_time > self.lunch_time[0] && self.interval_finish_time < self.lunch_time[1])
  end

  def interval_summary
    return unless interval_leave?

    _interval = Absence.default_where(member_id: self.member_id, 'start_at-lte': interval_start_time, 'finish_at-gte': interval_finish_time).take
    if _interval
      self.interval_absence_id = _interval.id
    else
      self.interval_absence_id = nil
    end

    _interval_seconds = TimeHelper.interval(self.interval_time[0], self.interval_time[1], interval_start: '12:30')
    interval = (_interval_seconds / 1800.0).ceil / 2.0
    self.interval_hours = interval
  end

  def financial_month
    @financial_month ||= FinancialMonth.current_month(self.attend_on)
  end

  def sync_workday
    if self.rest_day?
      self.workday = false
    end
  end

  def work_day?
    financial_month.work_day?(self.attend_on)
  end

  def rest_day?
    financial_month.rest_day?(self.attend_on)
  end
  
  class_methods do
    def compute_summary!
      self.where(processed: false).each do |at|
        at.compute_summary!
      end
    end
  
    def notify_completion
      normal_ids = self.distinct(:member_id).where(finish_time: nil).where.not(start_at: nil).pluck(:member_id)
      normal_ids.each do |member_id|
        AttendanceMailer.normal_completion(member_id).deliver_later
      end
  
      interval_ids = self.distinct(:member_id).where(interval_finish_at: nil).where.not(interval_start_at: nil).pluck(:member_id)
      interval_ids.each do |member_id|
        AttendanceMailer.interval_completion(member_id).deliver_later
      end
      [normal_ids, interval_ids]
    end
  end

end
