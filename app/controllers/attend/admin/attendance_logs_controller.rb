class Attend::Admin::AttendanceLogsController < Attend::Admin::BaseController
  before_action :set_attendance_log, only: [:show, :edit, :update, :analyze, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.permit(:attendance_id, :id)
    q_params.merge! params.fetch(:q, {}).permit!
    @attendance_logs = AttendanceLog.default_where(q_params).order(record_at: :desc).page(params[:page])
  end

  def my
    q_params = {
      member_id: current_member.child_ids
    }.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit('member.name')
    q_params.merge! params.permit(:member_id, :id)

    @attendance_logs = AttendanceLog.pending.default_where(q_params).order(id: :desc).page(params[:page])

    render :my, layout: 'my'
  end

  def check
    add_ids = params[:add_ids].split(',')
    if add_ids.present?
      als = AttendanceLog.where(id: add_ids)
      als.each do |al|
        al.do_trigger(state: 'valid')
      end
    end

    redirect_to my_admin_attendance_logs_url
  end

  def new
    if params[:attendance_id]
      @attendance = Attendance.find params[:attendance_id]
      attrs = { record_at: @attendance.attend_on, member_id: @attendance.member_id, attendance_id: @attendance.id }
    else
      attrs = {}
    end

    @attendance_log = AttendanceLog.new attrs
  end

  def create
    @attendance_log = AttendanceLog.new(attendance_log_params)

    respond_to do |format|
      if @attendance_log.save
        format.html { redirect_to admin_attendance_logs_url(attendance_id: @attendance_log.attendance_id), notice: 'Attendance log was successfully created.' }
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
      redirect_to admin_attendance_logs_url(attendance_id: @attendance_log.attendance_id), notice: 'Attendance log was successfully updated.'
    else
      render :edit
    end
  end

  def analyze
    @attendance_log.analyze
    redirect_to admin_attendance_logs_url(attendance_id: @attendance_log.attendance_id)
  end

  def destroy
    @attendance_log.destroy
    redirect_to admin_attendance_logs_url(attendance_id: @attendance_log.attendance_id), notice: 'Attendance log was successfully destroyed.'
  end

  private
  def set_attendance_log
    @attendance_log = AttendanceLog.find(params[:id])
  end

  def attendance_log_params
    q = params.fetch(:attendance_log, {}).permit(
      :record_at,
      :note,
      :member_id,
      :attendance_id
    )
    q.merge! source: 'admin'
  end

end
