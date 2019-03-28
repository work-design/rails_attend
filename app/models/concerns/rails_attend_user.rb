module RailsAttendUser
  extend ActiveSupport::Concern

  included do
    has_one :absence_stat, -> { where(year: Date.today.year) }
    has_many :absences, dependent: :destroy
    has_many :overtimes, dependent: :destroy
    has_many :attendances, dependent: :destroy
    has_many :attendance_logs, dependent: :nullify
    has_many :attendance_stats, dependent: :destroy
    has_many :attendance_settings, dependent: :destroy

    composed_of :absent, mapping: ['id', 'member_id']
  end

  def attendance_setting(date = Date.today)
    _attendance_setting = self.attendance_settings.default_where('financial_month.begin_date-lte': date).order(Arel.sql('`financial_months`.`begin_date` desc')).first
    _attendance_setting || self.attendance_settings.build(financial_month: FinancialMonth.current_month)
  end

  def on_time(date = Date.today)
    hour, min = (self.attendance_setting(date).on_time).split(':')
    date.in_time_zone(timezone).change(hour: hour, min: min)
  end

  def off_time(date = Date.today)
    hour, min = (self.attendance_setting(date).off_time).split(':')
    date.in_time_zone(timezone).change(hour: hour, min: min)
  end

  def lunch_time
    return @lunch_time if @lunch_time
    hour, min = (self.office.lunch_time.presence || LUNCH).split(':')
    start = Time.now.in_time_zone(timezone).change hour: hour, min: min
    finish = Time.now.in_time_zone(timezone).change hour: hour.to_i + 1, min: min
    @lunch_time = [start, finish]
  end

end