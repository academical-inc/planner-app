
$                 = require 'jquery'
ScheduleStore     = require '../stores/ScheduleStore'
SectionStore      = require '../stores/SectionStore'
EventStore        = require '../stores/EventStore'
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

  @openEventForm: (startDate, endDate)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.OPEN_EVENT_FORM
      startDate: startDate
      endDate: endDate

  @addEvent: (name, startDate, endDate, days)->
    event = ApiUtils.data.newEvent name, startDate, endDate, days
    PlannerDispatcher.handleViewAction
      type: ActionTypes.ADD_EVENT
      event: event
    @saveSchedule()

  @removeEvent: (event)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.REMOVE_EVENT
      event: event

  @saveSchedule: ->
    schedule = ScheduleStore.current()

    toSave = ApiUtils.data.scheduleToUpdate(
      schedule.name
      SectionStore.credits()
      SectionStore.sections().concat []  # Make a copy
      EventStore.events().concat []      # Make a copy
    )
    PlannerDispatcher.handleViewAction
      type: ActionTypes.SAVE_SCHEDULE
      schedule: toSave

    ApiUtils.saveSchedule schedule.id, toSave, (err, saved)->
      if err?
        PlannerDispatcher.handleServerAction
          type: ActionTypes.SAVE_SCHEDULE_FAIL
          schedule: toSave
          error: err
      else
        PlannerDispatcher.handleServerAction
          type: ActionTypes.SAVE_SCHEDULE_SUCCESS
          schedule: saved


module.exports = PlannerActions
