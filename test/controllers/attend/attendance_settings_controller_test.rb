require 'test_helper'

class Attend::AttendanceSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attendance_setting = create :attendance_setting
  end

  test "should get index" do
    get attendance_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_attendance_setting_url
    assert_response :success
  end

  test "should create attendance_setting" do
    assert_difference('AttendanceSetting.count') do
      post attendance_settings_url, params: { attendance_setting: { note: @attendance_setting.note, on_time: @attendance_setting.on_time, state: @attendance_setting.state } }
    end

    assert_redirected_to attendance_setting_url(AttendanceSetting.last)
  end

  test "should show attendance_setting" do
    get attendance_setting_url(@attendance_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_attendance_setting_url(@attendance_setting)
    assert_response :success
  end

  test "should update attendance_setting" do
    patch attendance_setting_url(@attendance_setting), params: { attendance_setting: { note: @attendance_setting.note, on_time: @attendance_setting.on_time, state: @attendance_setting.state } }
    assert_redirected_to attendance_setting_url(@attendance_setting)
  end

  test "should destroy attendance_setting" do
    assert_difference('AttendanceSetting.count', -1) do
      delete attendance_setting_url(@attendance_setting)
    end

    assert_redirected_to attendance_settings_url
  end
end
