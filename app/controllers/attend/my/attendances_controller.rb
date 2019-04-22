class Attend::My::AttendancesController < Attend::My::BaseController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit!
    q_params.merge! params.permit(:id)
    @attendances = current_member.attendances.default_where(q_params).order(attend_on: :desc).page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @attendance.update(attendance_params)
      redirect_to admin_attendances_url
    else
      render :edit
    end
  end

  def destroy
    @attendance.destroy
    redirect_to admin_attendances_url
  end

  private
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.fetch(:attendance, {}).permit(
      :start_at,
      :finish_at
    )
  end

end
