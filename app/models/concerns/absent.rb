class Absent
  attr_reader :member

	def initialize(member_id, type = nil)
		@member_id = member_id
		@type = type

		@member = Member.find(member_id)
		@absence_stat = AbsenceStat.find_by(member_id: member_id, year: Date.today.year)
  end

  def stat
		@stat ||= @member.absences.current_range_stat(Date.today.beginning_of_year, Date.today.end_of_year)
	end

	def left_stat

	end

	def used_hours(type = @type)
		stat[type.to_s].to_f
	end

	def total_hours(type = @type)
		col = type.underscore.split('_')[0] + '_days'
		begin
		  self.send(col).to_i * 8
		rescue NoMethodError
			nil
		end
	end

	def left_hours(type = @type)
		return unless total_hours(type)
		total_hours(type) - used_hours(type)
	end

	def annual_days
    case member.office&.country
		when 'China'
			china_annual_days
		when 'Switzerland'
			switzerland_annual_days
		when 'Serbia'
			common_annual_days(20)
		when 'Spain'
			common_annual_days(24)
		else
			china_annual_days
		end
	end

	# for china
	def china_annual_days
		dis = TimeHelper.exact_distance_time member.join_on, Date.today
		total_years = dis[:year] + (dis[:month] + member.previous_months.to_i) / 12
		if total_years >= 1 && total_years < 10
			base = 5
		elsif total_years >= 10 && total_years < 20
			base = 10
		elsif total_years >= 20
			base = 20
		else
			base = 0
		end

		if member.join_on.year == Date.today.year
			_base = (Date.today.end_of_year - member.join_on + 1) / 365.0 * base
			real_base = _base.floor
		else
			real_base = base
		end
		real_base + dis[:year].to_i
	end

	def switzerland_annual_days
    dis = TimeHelper.exact_distance_time member.join_on, Date.today
		_years = Date.today.year - member.join_on.year
		join_month = member.join_on.month
		if _years == 0
			base = (20 / 12.0 * dis[:year]).half_round
		elsif __years == 1
			base = (25 / 12.0 * (12 - join_month)).half_round + (20 / 12.0 * join_month).half_floor
		else
			base = 25
		end

		base
	end

	def common_annual_days(days = 20)
		days
	end

	def marriage_days
		0
	end

	def vacation_days
		0
	end

end
