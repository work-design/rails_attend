class Oa::My::AttendanceStatsController < Oa::My::BaseController
  before_action :set_attendance_stat, only: [:show]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit!
    @attendance_stats = current_member.attendance_stats.default_where(q_params).page(params[:page])
  end

  def show
  end

  private
  def set_attendance_stat
    @attendance_stat = AttendanceStat.find(params[:id])
  end

  def attendance_stat_params
    params.fetch(:attendance_stat, {}).permit(
      :member_id,
      :financial_month_id
    )
  end

end
