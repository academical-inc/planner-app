
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class WeekActions

  @changeWeek: (weekStart)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CHANGE_WEEK
      weekStart: weekStart


module.exports = WeekActions
