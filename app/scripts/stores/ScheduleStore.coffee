
Store             = require './Store'
_                 = require '../utils/HelperUtils'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_schedules      = []
_current        = null

_setCurrent = (current)->
  _current = current

_setSchedule = (idx, schedule)->
  _schedules[idx] = schedule

_setSchedules = (schedules)->
  _schedules = schedules
  _setCurrent _schedules[0]

_findDirty = (schedule)->
  _.findWithIdx _schedules, (el)-> el.name is schedule.name and el.dirty is true

_findToRemove = (id)->
  _.findWithIdx _schedules, (el)-> el.id is id and el.del is true

_reassignCurrent = (idx)->
  if _schedules[idx] is _current
    _current = if _schedules.length is 1   # idx must be 0
      null
    else                                   # length > 1
      if idx is 0
        _schedules[idx+1]
      else
        _schedules[idx-1]

_addSchedule = (schedule)->
  idx = _schedules.length
  schedule.dirty = true
  _schedules.push schedule
  _setCurrent _schedules[idx]

_removeScheduleAt = (idx)->
  shouldPass = _schedules.length is 0 or idx >= _schedules.length or idx < 0
  return if shouldPass
  _reassignCurrent idx
  _.removeAt _schedules, idx

_updateDirtySchedule = (schedule)->
  [dirty, idx] = _findDirty schedule
  if dirty?
    _setCurrent schedule if dirty is _current
    _setSchedule idx, schedule

_removeDirtySchedule = (schedule)->
  [dirty, idx] = _findDirty schedule
  _removeScheduleAt idx if dirty?

_openSchedule = (schedule)->
  toOpen = if schedule.id?
    _.find _schedules, (el)-> el.id is schedule.id
  else if schedule.name?
    _.find _schedules, (el)-> el.name is schedule.name
  _setCurrent toOpen if toOpen?

_removeSchedule = (id)->
  [toRemove, idx] = _.findWithIdx _schedules, (el)-> el.id is id
  if toRemove? and not toRemove.dirty is true
    _reassignCurrent idx
    toRemove.del = true

_finallyRemoveSchedule = (id)->
  [toRemove, idx] = _findToRemove id
  _removeScheduleAt idx if toRemove?

_revertRemovedSchedule = (id)->
  [toRemove, idx] = _findToRemove id
  toRemove.del = undefined if toRemove?


class ScheduleStore extends Store

  getAll: ->
    _.filter _schedules, (schedule)-> not schedule.del is true

  getCurrent: ->
    _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        _openSchedule action.schedule
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE
        _addSchedule action.schedule
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        _updateDirtySchedule action.schedule
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_FAIL
        _removeDirtySchedule action.schedule
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE
        _removeSchedule action.scheduleId
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        _finallyRemoveSchedule action.scheduleId
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_FAIL
        _revertRemovedSchedule action.scheduleId
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        _setSchedules action.schedules
        @emitChange()


module.exports = new ScheduleStore
