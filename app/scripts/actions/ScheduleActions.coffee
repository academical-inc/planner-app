
$                 = require 'jquery'
I18n              = require '../utils/I18n'
ApiUtils          = require '../utils/ApiUtils'
ActionUtils       = require '../utils/ActionUtils'
ScheduleFactory   = require '../factories/ScheduleFactory'
EventFactory      = require '../factories/EventFactory'
ScheduleStore     = require '../stores/ScheduleStore'
SectionStore      = require '../stores/SectionStore'
SectionColorStore = require '../stores/SectionColorStore'
EventStore        = require '../stores/EventStore'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
getSchedules = (action, success, fail)->
  PlannerDispatcher.dispatchViewAction
    type: action

  ApiUtils.getSchedules(
    ActionUtils.handleServerResponse(
      success
      fail
      (response)-> schedules: response
    )
  )
  return

createSchedule = (newSchedule)->
  PlannerDispatcher.dispatchViewAction
    type: ActionTypes.CREATE_SCHEDULE
    schedule: $.extend(true, {}, newSchedule)

  ApiUtils.createSchedule newSchedule, ActionUtils.handleServerResponse(
    ActionTypes.CREATE_SCHEDULE_SUCCESS
    ActionTypes.CREATE_SCHEDULE_FAIL
    (response)-> schedule: response
    -> schedule: newSchedule
  )
  return

# TODO Test
buildCurrentSchedule = ({id, exclude}={})->
  schedule = ScheduleStore.current id
  events   = EventStore.eventsExceptDeleted(id).map (event)->
    EventFactory.create event

  obj = $.extend true, {}, {
    id:             schedule.id
    name:           schedule.name
    studentId:      schedule.studentId
    schoolId:       schedule.schoolId
    term:           schedule.term
    sectionIds:     SectionStore.sections(id).map (sec)-> sec.id
    sectionColors:  SectionColorStore.colors id
    totalCredits:   SectionStore.credits id
    totalSections:  SectionStore.count id
    events:         events
  }

  ScheduleFactory.create obj, exclude: exclude


class ScheduleActions

  @openSchedule: (schedule)->
    PlannerDispatcher.dispatchViewAction
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

  @createSchedule: (scheduleName)->
    newSchedule = ScheduleFactory.create name: scheduleName
    createSchedule newSchedule

  @duplicateSchedule: ->
    newSchedule = buildCurrentSchedule exclude: ['id']
    newSchedule.name = I18n.t "copyOf", name: newSchedule.name
    createSchedule newSchedule

  @deleteSchedule: (scheduleId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.DELETE_SCHEDULE
      scheduleId: scheduleId

    ApiUtils.deleteSchedule scheduleId, ActionUtils.handleServerResponse(
      ActionTypes.DELETE_SCHEDULE_SUCCESS
      ActionTypes.DELETE_SCHEDULE_FAIL
      (response)-> scheduleId: scheduleId
      -> scheduleId: scheduleId
    )
    return

  @updateScheduleName: (scheduleId, name)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.UPDATE_SCHEDULE_NAME
      scheduleId: scheduleId
      name: name
    @saveSchedule scheduleId

  @saveSchedule: (id)->
    toSave = buildCurrentSchedule id: id
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.SAVE_SCHEDULE
      schedule: toSave

    ApiUtils.saveSchedule toSave.id, toSave, ActionUtils.handleServerResponse(
      ActionTypes.SAVE_SCHEDULE_SUCCESS
      ActionTypes.SAVE_SCHEDULE_FAIL
      (response)-> schedule: response
      -> scheduleId: toSave.id
    )


module.exports = ScheduleActions
