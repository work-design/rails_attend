$('#absence_compensatory').dropdown();
$('#absence_start_at_4i').dropdown();
$('#absence_start_at_5i').dropdown();
$('#absence_finish_at_4i').dropdown();
$('#absence_finish_at_5i').dropdown();
$('#absence_redeeming_days').dropdown();

$('#absence_type').dropdown({
  onChange: function (value, text, $selectedItem) {
    var search_url = new URL(window.location.origin);
    search_url.pathname = 'oa/absences/redeeming';
    search_url.search = $.param({type: value});

    fetch_xhr_script(search_url);
  }
});
