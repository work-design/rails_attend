class Attend::Admin::AttendanceSettingsController < Attend::Admin::BaseController
  before_action :set_attendance_setting, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit('member.name', 'member.email')
    q_params.merge! params.permit(:member_id, :id)

    @attendance_settings = AttendanceSetting.includes(:member, :financial_month).default_where(q_params).order(id: :desc).page(params[:page])
  end

  def my
    q_params = {
      member_id: current_member.child_ids
    }.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit('member.name', 'member.email')
    q_params.merge! params.permit(:member_id, :id)

    @attendance_settings = AttendanceSetting.includes(:member, :financial_month).default_where(q_params).order(id: :desc).page(params[:page])

    render :my, layout: 'my'
  end

  def check
    add_ids = params[:add_ids].split(',')
    if add_ids.present?
      als = AttendanceSetting.where(id: add_ids)
      als.each do |al|
        al.do_trigger(state: 'approved')
      end
    end

    redirect_back fallback_location: my_admin_attendance_settings_url
  end

  def new
    @attendance_setting = AttendanceSetting.new
  end

  def create
    @attendance_setting = AttendanceSetting.new(attendance_setting_params)

    if @attendance_setting.save
      redirect_to admin_attendance_settings_url(member_id: @attendance_setting.member_id), notice: 'Attendance setting was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @attendance_setting.update(attendance_setting_params)
      redirect_to admin_attendance_settings_url, notice: 'Attendance setting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendance_setting.destroy
    redirect_to admin_attendance_settings_url, notice: 'Attendance setting was successfully destroyed.'
  end

  private
  def set_attendance_setting
    @attendance_setting = AttendanceSetting.find(params[:id])
  end

  def attendance_setting_params
    params.fetch(:attendance_setting, {}).permit(
      :member_id,
      :financial_month_id,
      :on_time,
      :state,
      :note
    )
  end

end
