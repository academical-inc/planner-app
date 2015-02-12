
Store             = require './Store'
{ActionTypes}     = require '../constants/PlannerConstants'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'


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


StoreInstance = new ScheduleStore

StoreInstance.dispatchToken = PlannerDispatcher.register (payload)->
  action = payload.action

  switch action.type
    when ActionTypes.RECEIVE_SCHEDULES
      _addSchedules action.schedules
      StoreInstance.emitChange()
    else


module.exports = StoreInstance
