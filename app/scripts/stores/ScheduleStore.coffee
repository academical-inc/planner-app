
Store             = require './Store'
_                 = require '../utils/HelperUtils'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_schedules = []
_current   = null

setCurrent = (current)->
  _current = current

setSchedule = (idx, schedule)->
  _schedules[idx] = schedule

setSchedules = (schedules)->
  _schedules = schedules
  setCurrent _schedules[0]

findDirty = (schedule)->
  _.findWithIdx _schedules, (el)-> el.name is schedule.name and el.dirty is true

findToRemove = (id)->
  _.findWithIdx _schedules, (el)-> el.id is id and el.del is true

reassignCurrent = (idx)->
  if _schedules[idx] is _current
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

removeDirtySchedule = (schedule)->
  [dirty, idx] = findDirty schedule
  removeScheduleAt idx if dirty?

openSchedule = (schedule)->
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

addSection = (sectionId)->
  _current.sectionIds.push sectionId

removeSection = (sectionId)->
  _.findAndRemove _current.sectionIds, (id)-> id == sectionId


class ScheduleStore extends Store

  getAll: ->
    _.filter _schedules, (schedule)-> not schedule.del is true

  getCurrent: ->
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
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_FAIL
        revertRemovedSchedule action.scheduleId
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        setSchedules action.schedules
        @emitChange()
      when ActionTypes.ADD_SECTION
        addSection action.section.id
        @emitChange()
      when ActionTypes.REMOVE_SECTION
        removeSection action.sectionId
        @emitChange()


module.exports = new ScheduleStore
