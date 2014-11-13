
days = require('../constants/PlannerConstants').days

class DateUtils

  @now: ->
    new Date()

  @getDayForDate: (date)->
    # Assumes days array starts with monday
    l = days.length
    i = (date.getDay()-1+l) % l
    days[i]


module.exports = DateUtils
