
$                 = require 'jquery'
ScheduleStore     = require '../stores/ScheduleStore'
SectionStore      = require '../stores/SectionStore'
ColorStore        = require '../stores/SectionColorStore'
EventStore        = require '../stores/EventStore'
ApiUtils          = require '../utils/ApiUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'

# Private
getSchedules = (action, success, fail)->
  PlannerDispatcher.handleViewAction
    type: action

  ApiUtils.getSchedules (err, schedules)->
    if err?
      PlannerDispatcher.handleServerAction
        type: fail
        error: err
    else
      PlannerDispatcher.handleServerAction
        type: success
        schedules: schedules


class PlannerActions

  @openSchedule: (schedule)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.OPEN_SCHEDULE
      schedule: schedule

  @initSchedules: ->
    getSchedules(
      ActionTypes.GET_SCHEDULES
      ActionTypes.GET_SCHEDULES_SUCCESS
      ActionTypes.GET_SCHEDULES_FAIL
    )

  @updateSchedules: ->
    getSchedules(
      ActionTypes.UPDATE_SCHEDULES
      ActionTypes.UPDATE_SCHEDULES_SUCCESS
      ActionTypes.UPDATE_SCHEDULES_FAIL
    )

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

  @addSection: (section, color)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.ADD_SECTION
      section: section
      color: color
    @saveSchedule()

  @changeSectionColor: (sectionId, color)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.CHANGE_SECTION_COLOR
      sectionId: sectionId
      color: color
    @saveSchedule()

  @removeSection: (sectionId)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.REMOVE_SECTION
      sectionId: sectionId
    @saveSchedule()

  @addPreview: (section, previewType)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.ADD_SECTION_PREVIEW
      previewType: previewType
      section: section

  @removePreview: (previewType)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.REMOVE_SECTION_PREVIEW
      previewType: previewType

  @openEventForm: (startDt, endDt)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.OPEN_EVENT_FORM
      startDt: startDt
      endDt: endDt

  @addEvent: (name, startDt, endDt, days, repeatUntil, color)->
    event = ApiUtils.data.newEvent name, startDt, endDt, days,
      repeatUntil: repeatUntil
      color: color
    PlannerDispatcher.handleViewAction
      type: ActionTypes.ADD_EVENT
      event: event
    @saveSchedule()

  @updateEvent: (eventId, startDt, endDt, dayDelta)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.UPDATE_EVENT
      event:
        id: eventId
        startDt: startDt
        endDt: endDt
        dayDelta: dayDelta
    @saveSchedule()

  @changeEventColor: (eventId, color)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.CHANGE_EVENT_COLOR
      eventId: eventId
      color: color
    @saveSchedule()

  @removeEvent: (eventId)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.REMOVE_EVENT
      eventId: eventId
    @saveSchedule()

  @saveSchedule: ->
    schedule = ScheduleStore.current()

    toSave = ApiUtils.data.scheduleToUpdate(
      schedule.name
      SectionStore.credits()
      SectionStore.sections().concat []           # Make a copy
      EventStore.eventsExceptDeleted().concat []  # Make a copy
      $.extend {}, ColorStore.colors()
    )
    PlannerDispatcher.handleViewAction
      type: ActionTypes.SAVE_SCHEDULE
      schedule: toSave

    ApiUtils.saveSchedule schedule.id, toSave, (err, saved)->
      if err?
        PlannerDispatcher.handleServerAction
          type: ActionTypes.SAVE_SCHEDULE_FAIL
          scheduleId: schedule.id
          error: err
      else
        PlannerDispatcher.handleServerAction
          type: ActionTypes.SAVE_SCHEDULE_SUCCESS
          schedule: saved

  @changeWeek: (weekStart)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.CHANGE_WEEK
      weekStart: weekStart


module.exports = PlannerActions
