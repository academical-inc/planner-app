
Moment        = require 'moment'
{UiConstants} = require '../constants/PlannerConstants'

class DateUtils

  @date: (date)->
    if typeof date == 'string'
      Moment.parseZone date
    else
      Moment date.parseZone date

  # Assumes MO is 1 and SU is 7
  @getDayStr: (dayNo)->
    UiConstants.DAYS[dayNo-1]

  @getDayNo: (dayStr)->
    UiConstants.DAYS.indexOf(dayStr) + 1

  @now: ->
    Moment.utc()

  @utcFromStr: (str, format)->
    Moment.utc str, format

  @toUtc: (date)->
    date.utc()

  @toUtcOffset: (date, offset, keepTime=false)->
    @date(date).utcOffset offset, keepTime

  @inUtcOffset: (date, offset)->
    @toUtcOffset date, offset, true

  @getTimeStr: (date, format="h:mma")->
    @format date, format

  @getUtcTimeFromStr: (str, format="h:mma")->
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
    date = @date date
    # Need to do this because momentjs handles SU as 0
    day  = if date.day() == 0 and day == 7 then 0 else day
    date.day day
    date

  @setWeek: (date, week)->
    date = @date date
    date.week week
    date

  @setTimeAndFormat: (date, time, offset, format)->
    date = @setTime date, time, offset
    @format date, format

  @format: (date, format)->
    Moment(date).format format


module.exports = DateUtils
