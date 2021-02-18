module RailsAttend::Absence::WelfareLeave::AnnualLeave #年假
  extend ActiveSupport::Concern
	included do
		validate :validate_left_hours, if: -> { start_at_changed? || finish_at_changed? }
	end
	
	def validate_left_hours
		if self.hours > self.absent.left_hours.to_f
			self.errors.add :base, 'You do not have enough annual hours!'
		end
	end

end
