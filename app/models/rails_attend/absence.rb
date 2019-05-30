module RailsAttend::Absence
  extend ActiveSupport::Concern
  included do
    include CheckMachine
    serialize :redeeming_days, Array
    attribute :state, :string, default: 'init'
    attribute :hours, :float, default: 0
    belongs_to :member
    belongs_to :merged, class_name: self.name, optional: true
    has_many :divideds, class_name: self.name, foreign_key: 'merged_id'
  
    composed_of :absent, mapping: [
      ['member_id', 'member_id'],
      ['type', 'type']
    ]
  
    enum state: {
      init: 'init',
      approved: 'approved',
      denied: 'denied'
    }
  
    scope :current_range, -> (begin_date, finish_date) {
      default_where('start_at-gte': begin_date, 'finish_at-lte': finish_date, state: ['init', 'approved'])
    }
    scope :current_range_stat, -> (begin_date, finish_date) {
      current_range(begin_date, finish_date).group(:type).sum(:hours)
    }
    scope :current_range_events, -> (begin_date, finish_date, department_ids) {
      current_range(begin_date, finish_date).default_where('member.department_id': department_ids).map do |i|
        {
          title: i.member.name,
          start: i.start_at,
          end: i.finish_at,
          url: i.url_helpers.oa_absence_path(i.id)
        }
      end.as_json
    }
  
    validate :validate_same_month, if: -> { start_at_changed? || finish_at_changed? }
    validates :start_at, presence: true
    validates :finish_at, presence: true
  
    before_save :compute_hours
    after_create_commit :send_notification
  
    delegate :name, to: :member, prefix: true
    acts_as_notify :default,
                   only: [:hours, :start_at, :finish_at, :note],
                   methods: [:member_name, :type_i18n, :state_i18n]
  
    acts_as_notify :request,
                   only: [:hours, :start_at, :finish_at, :note],
                   methods: [:member_name, :type_i18n, :state_i18n],
                   cc_emails: [
                      -> (o){ o.member.office&.absence_email },
                      -> (o){ o.member.email },
                      -> (o){ o.cc_emails }
                    ]
  end
  
  def do_trigger(params = {})
    self.trigger_to(params.slice(:state))

    if self.approved?
      sync_attendance
    end

    self.class.transaction do
      self.save!
      to_notification(
        receiver: member,
        link: url_helpers.oa_absences_url(id: self.id),
        verbose: true
      )
    end
  end

  def send_notification
    to_notification(
      receiver: member.parent,
      link: url_helpers.my_admin_absences_url(id: self.id),
      code: :request,
      verbose: true
    )
  end

  def compute_hours
    _hours = 0

    if workdays.size > 2
      _hours += (workdays.size - 2) * 8
    end

    if workdays.size > 1
      _seconds_start = TimeHelper.interval(start_time, off_time, interval_start: lunch_time)
      _hours += _seconds_start.div(1800) / 2.0

      _seconds_finish = TimeHelper.interval(on_time, finish_time, interval_start: lunch_time)
      _hours += (_seconds_finish).div(1800) / 2.0
    else
      _start_at = start_time > on_time ? start_time : on_time
      _finish_at = finish_time < off_time ? finish_time : off_time
      _seconds = TimeHelper.interval(_start_at, _finish_at, interval_start: lunch_time)
      _hours = _seconds.div(1800) / 2.0
    end

    self.hours = _hours
    self.processed = true
  end

  def compute_hours!
    self.compute_hours
    self.save
  end

  def workdays
    @workdays ||= (start_time.to_date..finish_time.to_date).reject { |date| financial_month.rest_day?(date) }
  end

  def on_time
    return @on_time if @on_time

    if workdays.size > 1
      @on_time = self.member.on_time.change year: finish_at.year, month: finish_at.month, day: finish_at.day
    else
      @on_time = self.member.on_time.change year: start_at.year, month: start_at.month, day: start_at.day
    end
  end

  # todo repeat with attendance
  def start_time
    start_at.in_time_zone(member.timezone)
  end

  # todo repeat with attendance
  def finish_time
    finish_at.in_time_zone(member.timezone)
  end

  def off_time
    return @off_time if @off_time

    if workdays.size > 1
      @off_time = self.member.off_time.change year: start_at.year, month: start_at.month, day: start_at.day
    else
      @off_time = self.member.off_time.change year: finish_at.year, month: finish_at.month, day: finish_at.day
    end
  end

  def lunch_time
    @lunch_time ||= self.member.lunch_time[0].to_s(:time)
  end

  def sync_attendance
    self.workdays.each_with_index do |workday, index|
      att = self.member.attendances.find_or_initialize_by('attend_on': workday)

      if index == 0 && self.start_at <= self.on_time
        att.late_absence_id = self.id
      elsif index == 0 && self.finish_at >= self.off_time
        att.leave_absence_id = self.id
      else
        att.interval_absence_id = self.id
      end

      att.save
    end
  end

  def financial_months
    FinancialMonth.default_where('begin_date-lte': self.start_at.to_date, 'end_date-gte': self.finish_at.to_date)
  end

  def financial_month
    @financial_month ||= financial_months.take
  end

  def validate_same_month
    count = financial_months.count
    if count > 1
      self.errors.add :base, 'You can not request crossing financial month, please make more than one request'
    end
    if self.finish_at < self.start_at
      self.errors.add :base, 'Start time can not be later than end'
    end
  end

  def self.available_rest_days
    # todo improve performance, use bsearch
    _rest_days = FinancialMonth.available_rest_days.select { |d| d >= Date.today }
    Array(_rest_days).map { |d| [d.to_s, d.to_s] }
  end

end
