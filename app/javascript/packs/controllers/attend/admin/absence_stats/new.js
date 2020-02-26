$('#absence_stat_member_id').dropdown({
  apiSettings: {
    url: '/my/member/search?q={query}',
  },
  fields: {
    name: 'name',
    value: 'id'
  }
});
$('#absence_stat_year').dropdown();