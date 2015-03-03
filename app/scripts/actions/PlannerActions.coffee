
$                 = require 'jquery'
ApiUtils          = require '../utils/ApiUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class PlannerActions

  @openSchedule: (schedule)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.OPEN_SCHEDULE
      schedule: schedule

  @initSchedules: ->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.GET_SCHEDULES

    ApiUtils.getSchedules (err, schedules)->
      if err?
        PlannerDispatcher.handleServerAction
          type: ActionTypes.GET_SCHEDULES_FAIL
          error: err
      else
        PlannerDispatcher.handleServerAction
          type: ActionTypes.GET_SCHEDULES_SUCCESS
          schedules: schedules

  @createSchedule: (scheduleName, {dispatchInitial}={})->
    dispatchInitial ?= true

    newSchedule = ApiUtils.data.newSchedule scheduleName
    if dispatchInitial
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
    newSchedule

  @deleteSchedule: (scheduleId)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.DELETE_SCHEDULE
      scheduleId: scheduleId

    ApiUtils.deleteSchedule scheduleId, (err, schedule)->
      if err?
        PlannerDispatcher.handleServerAction
          type: ActionTypes.DELETE_SCHEDULE_FAIL
          error: err
          scheduleId: scheduleId
      else
        PlannerDispatcher.handleServerAction
          type: ActionTypes.DELETE_SCHEDULE_SUCCESS
          scheduleId: scheduleId

  @addSection: (section)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.ADD_SECTION
      section: section

  @removeSection: (sectionId)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.REMOVE_SECTION
      sectionId: sectionId

  @addSectionPreview: (section)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.ADD_SECTION_PREVIEW
      section: section

  @removeSectionPreview: ->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.REMOVE_SECTION_PREVIEW


module.exports = PlannerActions
