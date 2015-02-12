
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class PlannerActions

  @receiveSchedules: (schedules)->
    PlannerDispatcher.handleServerAction
      type: ActionTypes.RECEIVE_SCHEDULES
      schedules: schedules


module.exports = PlannerActions
