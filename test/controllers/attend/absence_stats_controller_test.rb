require 'test_helper'

class Attend::AbsenceStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @absence_stat = create :absence_stat
  end

  test "should get index" do
    get admin_absence_stats_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_absence_stat_url
    assert_response :success
  end

  test "should create admin_absence_stat" do
    assert_difference('AbsenceStat.count') do
      post admin_absence_stats_url, params: { admin_absence_stat: {  } }
    end

    assert_redirected_to admin_absence_stat_url(AbsenceStat.last)
  end

  test "should show admin_absence_stat" do
    get admin_absence_stat_url(@absence_stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_absence_stat_url(@absence_stat)
    assert_response :success
  end

  test "should update admin_absence_stat" do
    patch admin_absence_stat_url(@absence_stat), params: { admin_absence_stat: {  } }
    assert_redirected_to admin_absence_stat_url(@absence_stat)
  end

  test "should destroy admin_absence_stat" do
    assert_difference('AbsenceStat.count', -1) do
      delete admin_absence_stat_url(@absence_stat)
    end

    assert_redirected_to admin_absence_stats_url
  end
end
