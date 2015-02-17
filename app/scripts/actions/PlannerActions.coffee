
ApiUtils          = require '../utils/ApiUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class PlannerActions

  @getSchedules: ->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.GET_SCHEDULES

    ApiUtils.getSchedules (err, schedules)->
      if err?
        # TODO Dispatch something relevant
      else
        PlannerActions.receiveSchedules schedules

  @receiveSchedules: (schedules)->
    PlannerDispatcher.handleServerAction
      type: ActionTypes.GET_SCHEDULES_SUCCESS
      schedules: schedules

  @createSchedule: (scheduleName)->
    newSchedule = ApiUtils.data.newSchedule scheduleName
    PlannerDispatcher.handleViewAction
      type: ActionTypes.CREATE_SCHEDULE
      schedule: newSchedule

    ApiUtils.createSchedule newSchedule, (err, schedule)->
      if err?
        # TODO Dispatch something relevant
      else
        PlannerActions.receiveCreatedSchedule schedule

  @receiveCreatedSchedule: (schedule)->
    PlannerDispatcher.handleServerAction
      type: ActionTypes.CREATE_SCHEDULE_SUCCESS
      schedule: schedule


module.exports = PlannerActions
