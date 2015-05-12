
$         = require 'jquery'
Factory   = require './Factory'
ApiUtils  = require '../utils/ApiUtils'
DateUtils = require '../utils/DateUtils'


defaultRepeatUntil = (event)->
  school  = ApiUtils.currentSchool()
  termEnd = DateUtils.utcFromStr school.terms[0].endDate, "YYYY-MM-DD"

  DateUtils.setTimeAndFormat termEnd, event.startDt, school.utcOffset

# TODO Tests
class EventFactory extends Factory

  _fields: {
    "id": null
    "name": null
    "startDt": null
    "endDt": null
    "timezone": -> ApiUtils.currentSchool().timezone
    "location": null
    "description": null
    "color": null
    "recurrence.daysOfWeek": null
    "recurrence.freq": "WEEKLY"
    "recurrence.repeatUntil": defaultRepeatUntil
  }


module.exports = new EventFactory
