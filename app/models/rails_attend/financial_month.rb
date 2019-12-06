module RailsAttend::FinancialMonth
  extend ActiveSupport::Concern
  
  included do
    thread_mattr_accessor :current_country, instance_accessor: true

    attribute :begin_date, :date
    attribute :end_date, :date
    attribute :working_days, :string
    attribute :color, :string, default: '#8fdf82'
    
    belongs_to :organ, optional: true
    has_many :attendance_settings, dependent: :nullify

    validate :validate_date_range, if: -> { begin_date_changed? || end_date_changed? }
  end
  
  def workdays
    return @workdays if @workdays
    origin = (begin_date..end_date).reject { |day| day.on_weekend? }
    @workdays = origin + extra_workdays.pluck(:the_day) - holidays.pluck(:the_day)
  end

  def work_day?(date = Date.today)
    workdays.include?(date)
  end

  def rest_days
    return @rest_days if @rest_days
    origin = (begin_date..end_date).select { |day| day.on_weekend? }
    @rest_days = (origin - extra_workdays.pluck(:the_day) + holidays.pluck(:the_day)).uniq
  end

  def rest_day?(date = Date.today)
    rest_days.include?(date)
  end

  def extra_workdays
    ExtraDay.workday.default_where(country: FinancialMonth.current_country, 'the_day-gte': begin_date, 'the_day-lte': end_date)
  end

  def holidays
    ExtraDay.holiday.default_where(country: FinancialMonth.current_country, 'the_day-gte': begin_date, 'the_day-lte': end_date)
  end

  def extras
    (extra_workdays + holidays).map do |day|
      {
        title: day.name,
        start: day.the_day
      }
    end
  end

  def month
    self.end_date.month
  end

  def date_range
    [begin_date, end_date].join(' ~ ')
  end

  def events
    workdays.map do |workday|
      {
        title: 'Start',
        start: workday,
        color: self.color
      }
    end
  end

  def reset_attendance_settings
    attendance_settings.each do |as|
      as.sync_time
    end
  end

  def validate_date_range
    if self.end_date <= self.begin_date
      self.errors.add :base, 'End date must later than begin date!'
    end
  end

  def next_month
    FinancialMonth.default_where('begin_date-gt': self.end_date).order(begin_date: :asc).first
  end
  
  class_methods do
    def current_all
      FinancialMonth.default_where('end_date-gte': Date.today)
    end
  
    def next_all
      FinancialMonth.default_where('begin_date-gt': Date.today)
    end
  
    def current_month(day = Date.today)
      FinancialMonth.default_where('begin_date-lte': day, 'end_date-gte': day).take
    end
  
    def next_month(day = Date.today)
      self.current_month(day).next_month
    end
  
    def available_rest_days
      Array(self.current_month&.rest_days) + Array(self.next_month&.rest_days)
    end
  end
  
end
