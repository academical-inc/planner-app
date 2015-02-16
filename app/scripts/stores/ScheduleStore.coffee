
Store             = require './Store'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_schedules = []
_current   = null

_setCurrent = (idx)->
  _current = _schedules[idx]

_addSchedules = (schedules)->
  _schedules  = schedules
  _setCurrent 0


class ScheduleStore extends Store

  getAll: ->
    _schedules

  getCurrent: ->
    _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.CREATE_SCHEDULE
        _addSchedule action.schedule
        @emitChange()
      when ActionTypes.RECEIVE_CREATED_SCHEDULE
        _updateAddedSchedule action.schedule
        @emitChange()
      when ActionTypes.RECEIVE_SCHEDULES
        _setSchedules action.schedules
        @emitChange()


module.exports = new ScheduleStore
