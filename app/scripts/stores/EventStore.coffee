
Store            = require './Store'
ScheduleStore    = require './ScheduleStore'
ChildStoreHelper = require '../utils/ChildStoreHelper'
ApiUtils         = require '../utils/ApiUtils'
EventUtils       = require '../utils/EventUtils'
HelperUtils      = require '../utils/HelperUtils'
DateUtils        = require '../utils/DateUtils'
{ActionTypes}    = require '../constants/PlannerConstants'


# Private
_          = new ChildStoreHelper(ScheduleStore, 'events')
_utcOffset = -> ApiUtils.currentSchool().utcOffset

cleanScheduleEvents = (scheduleId)->
  events = _.elementsFor scheduleId
  events = HelperUtils.filter events, (ev)->
    not(ev.dirtyAdd is true) and not(ev.dirtyUpdate is true)
  events = events.map (ev)->
    delete ev.del if ev.del is true
    ev
  _.setElements scheduleId, events

updateTime = (date, time)->
  DateUtils.setTimeAndFormat date, time, _utcOffset()

updateDays = (event, dayDelta)->
  event.recurrence.daysOfWeek = event.recurrence.daysOfWeek.map (day)->
    dayNo = DateUtils.getDayNo day
    dayNo += dayDelta
    DateUtils.getDayStr dayNo

addEvent = (event)->
  event.dirtyAdd = true
  EventUtils.expandEventThruWeek event
  _.addElement event

updateEvent = (event)->
  [old, idx] = _.findElement event.id
  if old?
    old.startDt = updateTime old.startDt, event.startDate
    old.endDt   = updateTime old.endDt, event.endDate
    repeatUntil = updateTime old.recurrence.repeatUntil, event.startDate
    old.recurrence.repeatUntil = repeatUntil
    updateDays old, event.dayDelta
    old.dirtyUpdate = true
    EventUtils.expandEventThruWeek old,
      startDt: event.startDate
      endDt: event.endDate

removeEvent = (eventId)->
  [ev, i] = _.findElement eventId
  ev.del = true if ev?


class EventStore extends Store

  events: ->
    _.currentElements

  eventsExceptDeleted: ->
    HelperUtils.filter _.currentElements, (ev)-> not(ev.del is true)

  expandedEvents: ->
    EventUtils.getScheduleEvents _.currentElements

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        _.wait()
        _.setCurrent()
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        _.wait()
        _.initElementsMap action.schedules
        _.setCurrent()
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        _.wait()
        _.addSchedule action.schedule.id
        _.setCurrent()
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        _.wait()
        _.removeSchedule action.scheduleId
        _.setCurrent()
        @emitChange()
      when ActionTypes.ADD_EVENT
        addEvent action.event
        @emitChange()
      when ActionTypes.UPDATE_EVENT
        updateEvent action.event
        @emitChange()
      when ActionTypes.REMOVE_EVENT
        removeEvent action.eventId
        @emitChange()
      when ActionTypes.SAVE_SCHEDULE_SUCCESS
        _.wait()
        _.updateSchedule action.schedule
        if ScheduleStore.current().id == action.schedule.id
          _.setCurrent()
          @emitChange()
      when ActionTypes.SAVE_SCHEDULE_FAIL
        _.wait()
        cleanScheduleEvents action.scheduleId
        if ScheduleStore.current().id == action.scheduleId
          _.setCurrent()
          @emitChange()


module.exports = new EventStore
