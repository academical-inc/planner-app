
Store             = require './Store'
ScheduleStore     = require './ScheduleStore'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_pevsMap     = {}
_currentPevs = []


setPevsMap = (schedules)->
  schedules.forEach (schedule)->
    _pevsMap[schedule.id] = schedule.personalEvents

setCurrent = (scheduleId)->
  _currentPevs = _pevsMap[scheduleId]

update = ->
  PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
  setPevsMap ScheduleStore.getAll()
  setCurrent ScheduleStore.getCurrent().id


class PersonalEventStore extends Store

  getPersonalEvents: ->
    _currentPevs

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        setCurrent ScheduleStore.getCurrent().id
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        update()
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        update()
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        update()
        @emitChange()
      when ActionTypes.ADD_PERSONAL_EVENT
        update()
        @emitChange()
      when ActionTypes.REMOVE_PERSONAL_EVENT
        update()
        @emitChange()


module.exports = new PersonalEventStore
