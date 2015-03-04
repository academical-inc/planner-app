
Moment        = require 'moment'
{UiConstants} = require '../constants/PlannerConstants'

class DateUtils

  @now: ->
    Moment()

  @getDayForDate: (date)->
    days = UiConstants.days

    # Assumes days array starts with monday
    l = days.length
    i = (date.day()-1+l) % l
    days[i]

  @getTimeStr: (date, format="h:mma")->
    @format date, format

  @setTime: (date, time)->
    time = Moment time
    res  = Moment date
    res.hours time.hours()
    res.minutes time.minutes()
    res.seconds time.seconds()
    res

  @format: (date, format)->
    Moment(date).format format


module.exports = DateUtils
