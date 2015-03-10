
Moment        = require 'moment'
{UiConstants} = require '../constants/PlannerConstants'

class DateUtils

  @now: ->
    Moment()

  @utc: (str, format)->
    Moment.utc str, format

  @getDayStr: (dayNo)->
    # Assumes days array starts with monday
    days = UiConstants.days
    if dayNo != 0 then days[dayNo-1] else days[6]

  @getTimeStr: (date, format="h:mma")->
    @format date, format

  @getTimeFromStr: (str, format="h:mma")->
    Moment.utc(str, format)

  @setTime: (date, time)->
    time = Moment.utc time
    res  = Moment.utc date
    res.hours time.hours()
    res.minutes time.minutes()
    res.seconds time.seconds()
    res

  @setDay: (date, day)->
    date = Moment.utc date
    date.day day
    date

  @format: (date, format)->
    Moment(date).format format


module.exports = DateUtils
