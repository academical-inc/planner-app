
Moment        = require 'moment'
{UiConstants} = require '../constants/PlannerConstants'

class DateUtils

  # Assumes MO is 1 and SU is 7

  @getDayStr: (dayNo)->
    UiConstants.days[dayNo-1]

  @getDayNo: (dayStr)->
    UiConstants.days.indexOf(dayStr) + 1

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
    throw new Error("Week day must be between [1-7]") if day not in [1..7]
    date = Moment date
    # Need to do this because momentjs handles SU as 0
    day  = if date.day() == 0 and day == 7 then 0 else day
    date.day day
    date

  @format: (date, format)->
    Moment(date).format format


module.exports = DateUtils
