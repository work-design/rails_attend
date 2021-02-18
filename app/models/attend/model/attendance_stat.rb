module Attend
  module Model::AttendanceStat
    extend ActiveSupport::Concern

    included do
      attribute :costed_absence, :json, default: {}
      attribute :redeeming_absence, :json, default: {}
      attribute :free_absence, :json, default: {}
      attribute :allowance_days, :integer
      attribute :late_days, :integer
      attribute :absence_redeeming_hours, :float
      attribute :costed_absence, :string, limit: 1024
      attribute :cost_absence_hours, :float
      attribute :free_absence, :string, limit: 1024
      attribute :redeeming_absence, :string, limit: 1024
      attribute :holiday_redeeming_hours, :float
      attribute :processed, :boolean, default: false

      belongs_to :member
      belongs_to :financial_month
      has_many :absences,
               ->(o){ default_where('start_at-gte': o.financial_month.begin_date.beginning_of_day, 'finish_at-lte': o.financial_month.end_date.end_of_day) },  #todo timezone consider
               foreign_key: :member_id,
               primary_key: :member_id
      has_many :attendances,
               ->(o){ default_where('attend_on-gte': o.financial_month.begin_date, 'attend_on-lte': o.financial_month.end_date, workday: true) },
               foreign_key: :member_id,
               primary_key: :member_id
    end

    def compute_summary
      self.late_days = self.attendances.default_where({ 'absence_minutes-gt': 0, late_absence_id: nil, leave_absence_id: nil }, allow: [nil]).count
      self.allowance_days = self.attendances.default_where('kind-not': 'no_meal').count

      redeeming_hours = self.attendances.sum(:overtime_hours) <= 10 ? self.attendances.sum(:overtime_hours) : 10
      leave_hours = self.absences.where(type: 'PersonLeave').sum(:hours) >= 8 ? 8 : self.absences.where(type: 'PersonLeave').sum(:hours)

      self.absence_redeeming_hours = (redeeming_hours - leave_hours) > 0 ? redeeming_hours - leave_hours : 0

      if redeeming_hours > 2
        redeeming_hours -= 2
        self.holiday_redeeming_hours = redeeming_hours
      else
        self.absence_redeeming_hours = redeeming_hours
      end

      self.absence_summary
      self.processed = true
      self
    end

    def absence_summary
      absence_hash = self.attendances.default_where({ 'absence_minutes-gt': 0, 'absence_minutes-lte': 15, late_absence_id: nil, leave_absence_id: nil }, allow: [nil]).pluck(:absence_minutes, :attend_on).sort.map(&:reverse!).to_h

      time = 0
      absence_hash.each do |k, v|
        time += v
        break if time > 120
        self.free_absence[k] = absence_hash.delete(k)
      end
      absence_hash.merge! self.attendances.default_where({ 'absence_minutes-gt': 15, late_absence_id: nil, leave_absence_id: nil }, allow: [nil]).pluck(:absence_minutes, :attend_on).sort.map(&:reverse!).to_h

      remain = absence_redeeming_hours
      absence_hash.each do |k, v|
        o = (v / 30.0).ceil / 2.0
        remain -= o
        break if remain < 0
        self.redeeming_absence[k] = absence_hash.delete(k)
      end

      self.redeeming_absence = {} if absence_hash.blank?
      self.costed_absence = absence_hash
      self.cost_absence_hours = (self.costed_absence.values.sum / 30.0).ceil / 2.0
      self
    end

    def overtime_hash
      return @overtime_hash if @overtime_hash
      @overtime_hash = self.attendances.default_where('overtime_hours-gt': 0).pluck(:overtime_hours, :attend_on).sort.map(&:reverse!).to_h
    end

    def compute_summary!
      self.compute_summary
      self.save
    end

    class_methods do
      def init
        _financial_month = FinancialMonth.current_month

        Attendance.distinct(:member_id).default_where('attend_on-gte': _financial_month.begin_date, 'attend_on-lte': _financial_month.end_date).pluck(:member_id).each do |member_id|
          AttendanceStat.find_or_create_by(member_id: member_id, financial_month_id: _financial_month.id)
        end
      end

      def compute_summary!
        self.where(processed: false).each do |at|
          at.compute_summary!
        end
      end
    end

  end
end
