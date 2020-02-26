$('#attendance_setting_member_id').dropdown({
  apiSettings: {
    url: '/my/member/search?q={query}'
  },
  fields: {
    name: 'name',
    value: 'id'
  }
});
$('#attendance_setting_financial_month_id').dropdown();
$('#attendance_setting_on_time').dropdown();
