
Store           = require './Store'
_               = require '../utils/Utils'
I18n            = require '../utils/I18n'
ApiUtils        = require '../utils/ApiUtils'
ActionUtils     = require '../utils/ActionUtils'
ScheduleFactory = require '../factories/ScheduleFactory'
{ActionTypes}   = require '../constants/PlannerConstants'


# Private
_schedules     = []
_current       = null
_lastCurrent   = null


initSchedules = (schedules, initialScheduleId)->
  _schedules = schedules
  current = _schedules[0]
  if initialScheduleId
    matchedSchedule = _.find _schedules,
    (schedule) -> schedule.id == initialScheduleId
    current = matchedSchedule if matchedSchedule
  setCurrent current

setCurrent = (current)->
  _current = current

setLastCurrent = (lastCurrent)->
  _lastCurrent = lastCurrent

setSchedule = (idx, schedule)->
  _schedules[idx] = schedule

findDirty = (schedule)->
  _.findWithIdx _schedules, (el)-> el.name is schedule.name and el.dirty is true

findToRemove = (id)->
  _.findWithIdx _schedules, (el)-> el.id is id and el.del is true

reassignCurrent = (idx)->
  if _schedules[idx] is _current
    if _lastCurrent?
      _current = _lastCurrent
    else
      _current = if _schedules.length is 1   # idx must be 0
        null
      else                                   # length > 1
        if idx is 0
          _schedules[idx+1]
        else
          _schedules[idx-1]

addSchedule = (schedule)->
  idx = _schedules.length
  schedule.dirty = true
  _schedules.push schedule
  setLastCurrent _current
  setCurrent _schedules[idx]

removeScheduleAt = (idx)->
  shouldPass = _schedules.length is 0 or idx >= _schedules.length or idx < 0
  return if shouldPass
  reassignCurrent idx
  _.removeAt _schedules, idx

updateDirtySchedule = (schedule)->
  [dirty, idx] = findDirty schedule
  if dirty?
    setCurrent schedule if dirty is _current
    setSchedule idx, schedule
  setLastCurrent null

removeDirtySchedule = (schedule)->
  [dirty, idx] = findDirty schedule
  removeScheduleAt idx if dirty?
  setLastCurrent null

openSchedule = (schedule)->
  setLastCurrent null
  toOpen = if schedule.id?
    _.find _schedules, (el)-> el.id is schedule.id
  else if schedule.name?
    _.find _schedules, (el)-> el.name is schedule.name
  setCurrent toOpen if toOpen?

removeSchedule = (id)->
  if id?
    [toRemove, idx] = _.findWithIdx _schedules, (el)-> el.id is id
    if toRemove? and not toRemove.dirty is true
      reassignCurrent idx
      toRemove.del = true

finallyRemoveSchedule = (id)->
  [toRemove, idx] = findToRemove id
  removeScheduleAt idx if toRemove?

revertRemovedSchedule = (id)->
  [toRemove, idx] = findToRemove id
  delete toRemove.del if toRemove?

createSchedule = ->
  newSchedule = ScheduleFactory.create name: I18n.t "scheduleList.defaultName"
  ApiUtils.createSchedule newSchedule, ActionUtils.handleServerResponse(
    # TODO Duplication!! Almost unavoidable
    # This is beause I don't want to dispatch an action inside an action
    ActionTypes.CREATE_SCHEDULE_SUCCESS
    ActionTypes.CREATE_SCHEDULE_FAIL
    (response)-> schedule: response
    -> schedule: newSchedule
  )
  addSchedule newSchedule

updateScheduleName = (id, name)->
  schedule = _.find _schedules, (el)-> el.id is id
  schedule.prevName = schedule.name
  schedule.dirty = true
  schedule.name = name

revertNameUpdate = (id)->
  schedule = _.find _schedules, (el)-> el.id is id
  if schedule? and schedule.dirty is true and schedule.prevName?
    schedule.name = schedule.prevName
    delete schedule.dirty
    delete schedule.prevName


class ScheduleStore extends Store

  all: ->
    _schedules

  current: (id)->
    if id?
      _.find _schedules, (el)-> el.id is id
    else
      _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        openSchedule action.schedule
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE
        addSchedule action.schedule
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        updateDirtySchedule action.schedule
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_FAIL
        removeDirtySchedule action.schedule
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE
        removeSchedule action.scheduleId
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        finallyRemoveSchedule action.scheduleId
        createSchedule() if _schedules.length is 0
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_FAIL
        revertRemovedSchedule action.scheduleId
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        initSchedules action.schedules, action.initialScheduleId
        @emitChange()
      when ActionTypes.UPDATE_SCHEDULE_NAME
        updateScheduleName action.scheduleId, action.name
        @emitChange()
      when ActionTypes.SAVE_SCHEDULE_SUCCESS
        updateDirtySchedule action.schedule
        @emitChange()
      when ActionTypes.SAVE_SCHEDULE_FAIL
        revertNameUpdate action.scheduleId
        @emitChange()


module.exports = new ScheduleStore
