
$                 = require 'jquery'
Store             = require './Store'
ScheduleStore     = require './ScheduleStore'
HelperUtils       = require '../utils/HelperUtils'
EventUtils        = require '../utils/EventUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_              = $.extend true, {}, HelperUtils, EventUtils
_eventsMap     = {}
_currentEvents = []


initEventsMap = (schedules)->
  schedules.forEach (schedule)->
    updateSchedule schedule

setCurrent = (scheduleId)->
  _currentEvents = _eventsMap[scheduleId]

addEvent = (event)->
  # TODO should expand here if thats how I'm gonna do it
  _currentEvents.push event

removeEvent = (event)->
  _.findAndRemove _currentEvents, (ev)-> ev.id is event.id

addSchedule = (scheduleId)->
  _eventsMap[scheduleId] = []

removeSchedule = (scheduleId)->
  delete _eventsMap[scheduleId]

updateSchedule = (schedule)->
  _eventsMap[schedule.id] = schedule.events or []

wait = ->
  PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]

class EventStore extends Store

  events: ->
    _currentEvents

  expandedEvents: ->
    _.concatExpandedEvents _currentEvents

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        wait()
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        wait()
        initEventsMap action.schedules
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        wait()
        addSchedule action.schedule.id
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        wait()
        removeSchedule action.schedule.id
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.ADD_PERSONAL_EVENT
        addEvent action.event
      when ActionTypes.UPDATE_PERSONAL_EVENT
        @emitChange()
      when ActionTypes.REMOVE_PERSONAL_EVENT
        removeEvent action.event
      when ActionTypes.SAVE_SCHEDULE_SUCCESS
        wait()
        updateSchedule action.schedule
        if ScheduleStore.current().id == action.schedule.id
          @emitChange()


module.exports = new EventStore
