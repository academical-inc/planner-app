
$                 = require 'jquery'
_                 = require '../utils/Utils'
I18n              = require '../utils/I18n'
ApiUtils          = require '../utils/ApiUtils'
ActionUtils       = require '../utils/ActionUtils'
ScheduleFactory   = require '../factories/ScheduleFactory'
EventFactory      = require '../factories/EventFactory'
ScheduleStore     = require '../stores/ScheduleStore'
SectionStore      = require '../stores/SectionStore'
SectionColorStore = require '../stores/SectionColorStore'
EventStore        = require '../stores/EventStore'
NavError          = require '../errors/NavError'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{DebounceRates}   = require '../constants/PlannerConstants'


# Private
getSchedules = (userId, action, success, fail, initialScheduleId = null)->
  PlannerDispatcher.dispatchViewAction
    type: action

  ApiUtils.getSchedules(
    userId
    ActionUtils.handleServerResponse(
      success
      fail
      (response)-> schedules: response, initialScheduleId: initialScheduleId
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

saveSchedule = _.debounce (
  (scheduleId)->
    toSave = buildCurrentSchedule id: scheduleId
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.SAVE_SCHEDULE
      schedule: toSave

    ApiUtils.saveSchedule toSave.id, toSave, ActionUtils.handleServerResponse(
      ActionTypes.SAVE_SCHEDULE_SUCCESS
      ActionTypes.SAVE_SCHEDULE_FAIL
      (response)-> schedule: response
      -> scheduleId: toSave.id
    )
    return
  ), DebounceRates.SAVE_RATE


class ScheduleActions

  @openSchedule: (schedule)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.OPEN_SCHEDULE
      schedule: schedule

  @getSchedules: (userId, initialScheduleId)->
    getSchedules(
      userId
      ActionTypes.GET_SCHEDULES
      ActionTypes.GET_SCHEDULES_SUCCESS
      ActionTypes.GET_SCHEDULES_FAIL,
      initialScheduleId
    )

  @updateSchedules: (userId)->
    getSchedules(
      userId
      ActionTypes.UPDATE_SCHEDULES
      ActionTypes.UPDATE_SCHEDULES_SUCCESS
      ActionTypes.UPDATE_SCHEDULES_FAIL
    )

  @getSchedule: (scheduleId) ->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.GET_SCHEDULES

    ApiUtils.getSchedule(
      scheduleId,
      ActionUtils.handleServerResponse(
        ActionTypes.GET_SCHEDULES_SUCCESS
        ActionTypes.GET_SCHEDULES_FAIL
        (response)-> schedules: [response]
        (err)-> error: new NavError err
      )
    )

  @createSchedule: (scheduleName)->
    newSchedule = ScheduleFactory.create name: scheduleName
    createSchedule newSchedule

  @duplicateSchedule: (studentId = null) ->
    newSchedule = buildCurrentSchedule exclude: ['id']
    newSchedule.name = I18n.t "copyOf", name: newSchedule.name
    newSchedule.studentId = studentId if studentId
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

  @saveSchedule: (scheduleId)->
    saveSchedule scheduleId


module.exports = ScheduleActions
