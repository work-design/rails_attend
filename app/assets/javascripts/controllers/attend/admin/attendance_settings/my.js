//= require rails_com/checkbox


listenCheckedIds('attendance_setting_id');

$('input[name=attendance_setting_id]').change(function(){
  var remind_link = new URL($('#checked_attendance_setting')[0].href);
  $('#checked_attendance_setting').attr('href', remind_link.pathname + '?add_ids=' + getAddIds('attendance_setting_id'))
});

$('input[name=attendance_setting_all]').change(function(){
  var remind_link = new URL($('#checked_attendance_setting')[0].href);
  $('#checked_attendance_setting').attr('href', remind_link.pathname + '?add_ids=' + getAddIds('attendance_setting_id'))
});
