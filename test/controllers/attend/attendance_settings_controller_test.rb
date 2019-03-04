require 'test_helper'

class Attend::AttendanceSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oa_attendance_setting = oa_attendance_settings(:one)
  end

  test "should get index" do
    get oa_attendance_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_oa_attendance_setting_url
    assert_response :success
  end

  test "should create oa_attendance_setting" do
    assert_difference('AttendanceSetting.count') do
      post oa_attendance_settings_url, params: { oa_attendance_setting: { note: @oa_attendance_setting.note, on_time: @oa_attendance_setting.on_time, state: @oa_attendance_setting.state } }
    end

    assert_redirected_to oa_attendance_setting_url(AttendanceSetting.last)
  end

  test "should show oa_attendance_setting" do
    get oa_attendance_setting_url(@oa_attendance_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_oa_attendance_setting_url(@oa_attendance_setting)
    assert_response :success
  end

  test "should update oa_attendance_setting" do
    patch oa_attendance_setting_url(@oa_attendance_setting), params: { oa_attendance_setting: { note: @oa_attendance_setting.note, on_time: @oa_attendance_setting.on_time, state: @oa_attendance_setting.state } }
    assert_redirected_to oa_attendance_setting_url(@oa_attendance_setting)
  end

  test "should destroy oa_attendance_setting" do
    assert_difference('AttendanceSetting.count', -1) do
      delete oa_attendance_setting_url(@oa_attendance_setting)
    end

    assert_redirected_to oa_attendance_settings_url
  end
end
