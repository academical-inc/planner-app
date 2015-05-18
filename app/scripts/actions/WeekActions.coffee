
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class WeekActions

  @setWeek: (weekStart)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.SET_WEEK
      weekStart: weekStart


module.exports = WeekActions
