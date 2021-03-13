import { Controller } from 'stimulus'
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'

class CalendarController extends Controller {
  static values = {
    start: String,
    end: String,
    url: String
  }

  connect() {
    console.debug('Calendar Controller connected!')
    this.xx()
  }

  xx() {
    let calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin],
      headerToolbar: {
        left: 'prev,next',
        center: 'title',
        right: ''
      },
      showNonCurrentDates: false,
      fixedWeekCount: false,
      validRange: {
        start: this.startValue,
        end: this.endValue
      },

      // height
      aspectRatio: 3,
      height: 'auto',
      firstDay: 1,

      // events
      eventSources: [
        {
          url: this.urlValue,
          format: 'json',
          color: '#8fdf82',
          rendering: 'background'
        }
      ]
    })
    calendar.render()
  }

  reloadCalendar(source, newSource) {
    $('#calendar').fullCalendar('removeEventSource', source).fullCalendar('addEventSource', newSource)
  }

  get calendar() {
    return new Calendar(this.element)
  }

}

application.register('calendar', CalendarController)
