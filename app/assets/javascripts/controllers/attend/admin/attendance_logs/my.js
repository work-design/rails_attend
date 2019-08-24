import 'rails_com/checkbox'


listenCheckedIds('attendance_log_id');

$('input[name=attendance_log_id]').change(function(){
  var remind_link = new URL($('#checked_attendance_log')[0].href);
  $('#checked_attendance_log').attr('href', remind_link.pathname + '?add_ids=' + getAddIds('attendance_log_id'))
});

$('input[name=attendance_log_all]').change(function(){
  var remind_link = new URL($('#checked_attendance_log')[0].href);
  $('#checked_attendance_log').attr('href', remind_link.pathname + '?add_ids=' + getAddIds('attendance_log_id'))
});
