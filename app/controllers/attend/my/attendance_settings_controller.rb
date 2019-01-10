class Oa::My::AttendanceSettingsController < Oa::My::BaseController
  before_action :set_attendance_setting, only: [:edit, :update]

  def index
    @attendance_setting = current_member.attendance_setting
    @attendance_settings = current_member.attendance_settings.default_where('financial_month.begin_date-gt': Date.today).order(financial_month_id: :asc)
  end

  def new
    @attendance_setting = current_member.attendance_settings.build
  end

  def create
    @attendance_setting = current_member.attendance_settings.build(attendance_setting_params)

    if @attendance_setting.save
      redirect_to my_attendance_settings_url, notice: 'Attendance setting was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @attendance_setting.update(attendance_setting_params)
      redirect_to my_attendance_settings_url, notice: 'Attendance setting was successfully updated.'
    else
      render :edit
    end
  end

  private
  def set_attendance_setting
    @attendance_setting = current_member.attendance_settings.find params[:id]
  end

  def attendance_setting_params
    params.fetch(:attendance_setting, {}).permit(
      :on_time,
      :financial_month_id,
      :state,
      :note
    )
  end

end
