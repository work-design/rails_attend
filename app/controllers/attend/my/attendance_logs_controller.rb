class Attend::My::AttendanceLogsController < Attend::My::BaseController
  before_action :set_attendance_log, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {

    }.with_indifferent_access
    q_params.merge! params.permit(:attendance_id)
    q_params.merge! params.fetch(:q, {}).permit!
    @attendance_logs = current_member.attendance_logs.default_where(q_params).order(record_at: :desc).page(params[:page])
  end

  def new
    if params[:attendance_id]
      @attendance = current_member.attendances.find params[:attendance_id]
      attrs = { record_at:  @attendance.attend_on.change(hour: current_member.off_time.hour, min: current_member.off_time.min) }
    else
      attrs = {}
    end

    @attendance_log = AttendanceLog.new attrs
  end

  def create
    @attendance_log = AttendanceLog.new(attendance_log_params)

    respond_to do |format|
      if @attendance_log.save
        format.html { redirect_to my_attendance_logs_url(attendance_id: @attendance_log.attendance_id) }
        format.js do
          @attendance_log.compute
        end
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @attendance_log.update(attendance_log_params)
      redirect_to my_attendance_logs_url(attendance_id: @attendance_log.attendance_id)
    else
      render :edit
    end
  end

  def destroy
    @attendance_log.destroy
    redirect_to my_attendance_logs_url(attendance_id: @attendance_log.attendance_id)
  end

  private
  def set_attendance_log
    @attendance_log = AttendanceLog.find(params[:id])
  end

  def attendance_log_params
    q = params.fetch(:attendance_log, {}).permit(
      :record_at,
      :note
    )
    q.merge! source: 'myself', member_id: current_member.id
  end

end
