require 'test_helper'

class Attend::AttendanceLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oa_attendance_log = oa_attendance_logs(:one)
  end

  test "should get index" do
    get oa_attendance_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_oa_attendance_log_url
    assert_response :success
  end

  test "should create oa_attendance_log" do
    assert_difference('AttendanceLog.count') do
      post oa_attendance_logs_url, params: { oa_attendance_log: {  } }
    end

    assert_redirected_to oa_attendance_log_url(AttendanceLog.last)
  end

  test "should show oa_attendance_log" do
    get oa_attendance_log_url(@oa_attendance_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_oa_attendance_log_url(@oa_attendance_log)
    assert_response :success
  end

  test "should update oa_attendance_log" do
    patch oa_attendance_log_url(@oa_attendance_log), params: { oa_attendance_log: {  } }
    assert_redirected_to oa_attendance_log_url(@oa_attendance_log)
  end

  test "should destroy oa_attendance_log" do
    assert_difference('AttendanceLog.count', -1) do
      delete oa_attendance_log_url(@oa_attendance_log)
    end

    assert_redirected_to oa_attendance_logs_url
  end
end
