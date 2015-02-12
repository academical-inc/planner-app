
{UiConstants} = require '../constants/PlannerConstants'

class DateUtils

  @now: ->
    new Date()

  @getDayForDate: (date)->
    days = UiConstants.days

    # Assumes days array starts with monday
    l = days.length
    i = (date.getDay()-1+l) % l
    days[i]


module.exports = DateUtils
