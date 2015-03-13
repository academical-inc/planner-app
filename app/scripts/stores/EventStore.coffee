
Store            = require './Store'
ScheduleStore    = require './ScheduleStore'
ChildStoreHelper = require '../utils/ChildStoreHelper'
ApiUtils         = require '../utils/ApiUtils'
EventUtils       = require '../utils/EventUtils'
{ActionTypes}    = require '../constants/PlannerConstants'


# Private
_              = new ChildStoreHelper(ScheduleStore, 'events')
_currentSchool = ApiUtils.currentSchool


class EventStore extends Store

  events: ->
    _.currentElements

  expandedEvents: ->
    EventUtils.concatExpandedEvents _.currentElements

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
        # TODO should expand here if thats how I'm gonna do it
        action.event.dirty = true
        EventUtils.expandEventThruWeek action.event, _currentSchool().utcOffset
        _.addElement action.event
        @emitChange()
      when ActionTypes.UPDATE_EVENT
        @emitChange()
      when ActionTypes.REMOVE_EVENT
        _.removeElement action.eventId
      when ActionTypes.SAVE_SCHEDULE_SUCCESS
        _.wait()
        _.updateSchedule action.schedule
        if ScheduleStore.current().id == action.schedule.id
          _.setCurrent()
          @emitChange()


module.exports = new EventStore
