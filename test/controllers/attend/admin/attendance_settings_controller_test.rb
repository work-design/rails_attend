require 'test_helper'

class Attend::Admin::AttendanceSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attendance_setting = create :attendance_setting
  end

  test "should get index" do
    get admin_attendance_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_attendance_setting_url
    assert_response :success
  end

  test "should create admin_attendance_setting" do
    assert_difference('AttendanceSetting.count') do
      post admin_attendance_settings_url, params: { admin_attendance_setting: { note: @attendance_setting.note, on_time: @attendance_setting.on_time, state: @attendance_setting.state } }
    end

    assert_redirected_to admin_attendance_setting_url(AttendanceSetting.last)
  end

  test "should show admin_attendance_setting" do
    get admin_attendance_setting_url(@attendance_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_attendance_setting_url(@attendance_setting)
    assert_response :success
  end

  test "should update admin_attendance_setting" do
    patch admin_attendance_setting_url(@attendance_setting), params: { admin_attendance_setting: { note: @attendance_setting.note, on_time: @attendance_setting.on_time, state: @attendance_setting.state } }
    assert_redirected_to admin_attendance_setting_url(@attendance_setting)
  end

  test "should destroy admin_attendance_setting" do
    assert_difference('AttendanceSetting.count', -1) do
      delete admin_attendance_setting_url(@attendance_setting)
    end

    assert_redirected_to admin_attendance_settings_url
  end
end
