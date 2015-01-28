
UIConstants = require('../constants/PlannerConstants').ui

class DateUtils

  @now: ->
    new Date()

  @getDayForDate: (date)->
    days = UIConstants.days

    # Assumes days array starts with monday
    l = days.length
    i = (date.getDay()-1+l) % l
    days[i]


module.exports = DateUtils
