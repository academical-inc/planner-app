
$           = require 'jquery'
Factory     = require './Factory'
SchoolStore = require '../stores/SchoolStore'
DateUtils   = require '../utils/DateUtils'


# TODO Tests
class EventFactory extends Factory

  _fields: {
    "id": null
    "name": null
    "startDt": null
    "endDt": null
    "timezone": -> SchoolStore.school().timezone
    "location": null
    "description": null
    "color": null
    "recurrence.daysOfWeek": null
    "recurrence.freq": "WEEKLY"
    "recurrence.repeatUntil": null
  }


module.exports = new EventFactory
