
Moment        = require 'moment'
{UiConstants} = require '../constants/PlannerConstants'

class DateUtils

  @now: ->
    Moment.utc()

  @utcFromStr: (str, format)->
    Moment.utc str, format

  @toUtc: (date)->
    date.utc()

  @toUtcOffset: (date, offset, keepTime=false)->
    res = if typeof date == 'string'
      Moment.parseZone date
    else
      Moment date
    res.utcOffset offset, keepTime

  @inUtcOffset: (date, offset)->
    @toUtcOffset date, offset, true

  @getDayStr: (dayNo)->
    # Assumes days array starts with monday
    days = UiConstants.days
    if dayNo != 0 then days[dayNo-1] else days[6]

  @getTimeStr: (date, format="h:mma")->
    @format date, format

  @getTimeFromStr: (str, format="h:mma")->
    @utcFromStr str, format

  @setTime: (date, time, offset=0)->
    time = @inUtcOffset time, offset
    res  = @inUtcOffset date, offset
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
