
Store             = require './Store'
_                 = require '../utils/HelperUtils'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_schedules      = []
_dirtySchedules = []
_current        = null

_setCurrent = (idx)->
  _current = _schedules[idx]

_setSchedule = (idx, schedule)->
  _schedules[idx] = schedule

_setSchedules = (schedules)->
  _schedules  = schedules
  _setCurrent 0

_addDirtySchedule = (name, idx)->
  _dirtySchedules.push name: name, idx: idx

_addSchedule = (schedule)->
  idx = _schedules.length
  _addDirtySchedule schedule.name, idx
  _schedules.push schedule
  _setCurrent idx

_updateAddedSchedule = (schedule)->
  dirty = _.findAndRemove _dirtySchedules, (el)->
    el.name is schedule.name
  _setSchedule dirty.idx, schedule if dirty?


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
