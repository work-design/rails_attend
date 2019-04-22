class Attend::Admin::AttendanceStatsController < Attend::Admin::BaseController
  before_action :set_attendance_stat, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit!
    @attendance_stats = AttendanceStat.includes(:member).default_where(q_params).page(params[:page])
  end

  def new
    @attendance_stat = AttendanceStat.new
  end

  def create
    @attendance_stat = AttendanceStat.new(attendance_stat_params)

    if @attendance_stat.save
      redirect_to admin_attendance_stats_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @attendance_stat.update(attendance_stat_params)
      redirect_to admin_attendance_stats_url
    else
      render :edit
    end
  end

  def destroy
    @attendance_stat.destroy
    redirect_to admin_attendance_stats_url
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
