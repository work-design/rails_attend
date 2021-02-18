module Attend
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_one :absence_stat, -> { where(year: Date.today.year) }
      has_many :absences, class_name: 'Attend::Absence', dependent: :destroy
      has_many :overtimes, class_name: 'Attend::Overtime', dependent: :destroy
      has_many :attendances, class_name: 'Attend::Attendance', dependent: :destroy
      has_many :attendance_logs, class_name: 'Attend::AttendanceLog', dependent: :nullify
      has_many :attendance_stats, class_name: 'Attend::AttendanceStat', dependent: :destroy
      has_many :attendance_settings, class_name: 'Attend::AttendanceSetting', dependent: :destroy

      composed_of :absent, mapping: ['id', 'member_id']
    end

    def attendance_setting(date = Date.today)
      _attendance_setting = self.attendance_settings.default_where('financial_month.begin_date-lte': date).first
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

  end
end
