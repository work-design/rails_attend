import 'rails_taxon/outer_search'

$(document).ready(function() {

  $('#calendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    aspectRatio: 3,
    height: 'auto',
    firstDay: 1,
    fixedWeekCount: false,
    eventSources: [
      {
        url: '/oa/calendar/events',
        data: {
          department_id: $('#calendar').data("department-id")
        },
        error: function() {
          alert('there was an error while fetching events!');
        }
      }
    ],
    displayEventTime: false,
    eventMouseover: function(event, jsEvent, view) {
      $(this).popup({
        content: event.start.format('Do h:mm a') + '-' + event.end.format('Do h:mm a'),
        position: 'top center',
        distanceAway: -4,
        className: {
          popup: 'ui inverted small popup',
        }
      }).popup('toggle');
    }
  })

});

document.addEventListener('turbolinks:before-cache', function() {
  $('#calendar').fullCalendar('delete');
  $('#calendar').html('');
  $('.ui.popup').remove();
})

function reloadCalendar(source, newSource) {
  $('#calendar').fullCalendar('removeEventSource', source)
    .fullCalendar('addEventSource', newSource)
}
