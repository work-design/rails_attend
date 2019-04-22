class Attend::Admin::AttendancesController < Attend::Admin::BaseController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  def index
    q_params = params.fetch(:q, {}).permit!
    @attendances = Attendance.includes(:member).default_where(q_params).order(id: :desc).page(params[:page])
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to admin_attendances_url
    else
      render :new
    end
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
