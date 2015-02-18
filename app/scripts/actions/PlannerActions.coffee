
$                 = require 'jquery'
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
        PlannerDispatcher.handleServerAction
          type: ActionTypes.GET_SCHEDULES_SUCCESS
          schedules: schedules

  @createSchedule: (scheduleName)->
    newSchedule = ApiUtils.data.newSchedule scheduleName
    PlannerDispatcher.handleViewAction
      type: ActionTypes.CREATE_SCHEDULE
      schedule: $.extend(true, {}, newSchedule)

    ApiUtils.createSchedule newSchedule, (err, schedule)->
      if err?
        PlannerDispatcher.handleServerAction
          type: ActionTypes.CREATE_SCHEDULE_FAIL
          schedule: newSchedule
          error: err
      else
        PlannerDispatcher.handleServerAction
          type: ActionTypes.CREATE_SCHEDULE_SUCCESS
          schedule: schedule


module.exports = PlannerActions
