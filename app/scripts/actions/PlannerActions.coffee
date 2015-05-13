
$                 = require 'jquery'
ApiUtils          = require '../utils/ApiUtils'
I18n              = require '../utils/I18n'
ScheduleFactory   = require '../factories/ScheduleFactory'
EventFactory      = require '../factories/EventFactory'
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

createSchedule = (newSchedule, dispatchInitial, action, success, fail)->
  if dispatchInitial
    PlannerDispatcher.handleViewAction
      type: action
      schedule: $.extend(true, {}, newSchedule)

  ApiUtils.createSchedule newSchedule, (err, schedule)->
    if err?
      PlannerDispatcher.handleServerAction
        type: fail
        schedule: newSchedule
        error: err
    else
      PlannerDispatcher.handleServerAction
        type: success
        schedule: schedule
  newSchedule


# TODO Tests
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
    newSchedule = ScheduleFactory.create name: scheduleName
    createSchedule(
      newSchedule
      dispatchInitial
      ActionTypes.CREATE_SCHEDULE
      ActionTypes.CREATE_SCHEDULE_SUCCESS
      ActionTypes.CREATE_SCHEDULE_FAIL
    )

  @duplicateSchedule: ->
    newSchedule = ScheduleFactory.buildCurrent exclude: ['id']
    newSchedule.name = I18n.t "copyOf", name: newSchedule.name
    createSchedule(
      newSchedule
      true
      ActionTypes.CREATE_SCHEDULE
      ActionTypes.CREATE_SCHEDULE_SUCCESS
      ActionTypes.CREATE_SCHEDULE_FAIL
    )

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

  @updateScheduleName: (scheduleId, name)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.UPDATE_SCHEDULE_NAME
      scheduleId: scheduleId
      name: name
    @saveSchedule scheduleId

  @saveSchedule: (id)->
    toSave = ScheduleFactory.buildCurrent id: id
    PlannerDispatcher.handleViewAction
      type: ActionTypes.SAVE_SCHEDULE
      schedule: toSave

    ApiUtils.saveSchedule toSave.id, toSave, (err, saved)->
      if err?
        PlannerDispatcher.handleServerAction
          type: ActionTypes.SAVE_SCHEDULE_FAIL
          scheduleId: toSave.id
          error: err
      else
        PlannerDispatcher.handleServerAction
          type: ActionTypes.SAVE_SCHEDULE_SUCCESS
          schedule: saved

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

  @addEvent: (name, startDt, endDt, days, repeatUntil, color)->
    event = EventFactory.create
      name: name
      startDt: startDt
      endDt: endDt
      color: color
      recurrence:
        daysOfWeek: days
        repeatUntil: repeatUntil
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

  @changeWeek: (weekStart)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.CHANGE_WEEK
      weekStart: weekStart

  @openEventForm: (startDt, endDt)->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.OPEN_EVENT_FORM
      startDt: startDt
      endDt: endDt

  @openSummaryDialog: ->
    PlannerDispatcher.handleViewAction
      type: ActionTypes.OPEN_SUMMARY_DIALOG


module.exports = PlannerActions
