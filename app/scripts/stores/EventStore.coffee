#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

$                = require 'jquery'
Store            = require './Store'
SchoolStore      = require './SchoolStore'
ScheduleStore    = require './ScheduleStore'
ChildStoreHelper = require '../utils/ChildStoreHelper'
EventUtils       = require '../utils/EventUtils'
DateUtils        = require '../utils/DateUtils'
{ActionTypes}    = require '../constants/PlannerConstants'


# Private
_         = new ChildStoreHelper(ScheduleStore, 'events')
_toRevert = {}

expandEvent = (ev)->
  ev.expanded = EventUtils.expandEvents ev, [ev] if not ev.expanded?

expandCurrent = ->
  _.currentElements.forEach expandEvent

setCurrent = ->
  _.setCurrent()
  expandCurrent()

cleanScheduleEvents = (scheduleId)->
  events = _.elementsFor scheduleId
  events = events.filter (ev)-> not(ev.dirtyAdd is true)
  events = events.map (ev)->
    delete ev.del if ev.del is true
    if ev.dirtyUpdate is true
      ev = _toRevert[ev.id]
      delete _toRevert[ev.id]
    ev
  _.setElements scheduleId, events

updateTime = (date, time)->
  DateUtils.setTimeAndFormat date, time, SchoolStore.school().utcOffset

updateDate = (date, dayDelta, time)->
  date = updateTime date, time
  date = DateUtils.setDate date, dayDelta: dayDelta
  date.format()

updateDays = (event, dayDelta)->
  event.recurrence.daysOfWeek = event.recurrence.daysOfWeek.map (day)->
    dayNo = DateUtils.getDayNo day
    dayNo += dayDelta
    dayNo = if dayNo > 7
      dayNo % 7
    else if dayNo <= 0
      dayNo + 7
    else
      dayNo
    DateUtils.getDayStr dayNo

addEvent = (event)->
  event.dirtyAdd = true
  event.expanded = EventUtils.expandThruWeek event
  _.addElement event

updateEvent = (event)->
  [old, idx] = _.findElement event.id
  if old?
    delete old.expanded
    _toRevert[old.id] = $.extend true, {}, old
    old.dirtyUpdate = true
    old.startDt = updateDate old.startDt, event.dayDelta, event.startDt
    old.endDt   = updateDate old.endDt, event.dayDelta, event.endDt
    repeatUntil = updateTime old.recurrence.repeatUntil, event.startDt
    old.recurrence.repeatUntil = repeatUntil
    updateDays old, event.dayDelta
    old.expanded = EventUtils.expandThruWeek old,
      startDt: event.startDt
      endDt: event.endDt

removeEvent = (eventId)->
  [ev, i] = _.findElement eventId
  ev.del = true if ev?

changeColor = (eventId, color)->
  [event, idx] = _.findElement eventId
  event.color = color if event?


# TODO Test Event expansion
class EventStore extends Store

  events: (id)->
    _.currentElementsOr(id) or []

  eventsExceptDirtyAdded: (id)->
    @events(id).filter (ev)-> not(ev.dirtyAdd is true)

  eventsExceptDeleted: (id)->
    @events(id).filter (ev)-> not(ev.del is true)

  expandedEvents: (id)->
    EventUtils.concatExpandedEvents @events(id)

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        _.wait()
        setCurrent()
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        _.wait()
        _.initElementsMap action.schedules
        setCurrent()
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        _.wait()
        _.updateSchedule action.schedule
        setCurrent()
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        _.wait()
        _.removeSchedule action.scheduleId
        setCurrent()
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
      when ActionTypes.CHANGE_EVENT_COLOR
        changeColor action.eventId, action.color
        @emitChange()
      when ActionTypes.SAVE_SCHEDULE_SUCCESS
        _.wait()
        _.updateSchedule action.schedule
        if ScheduleStore.current().id == action.schedule.id
          setCurrent()
          @emitChange()
      when ActionTypes.SAVE_SCHEDULE_FAIL
        _.wait()
        cleanScheduleEvents action.scheduleId
        if ScheduleStore.current().id == action.scheduleId
          setCurrent()
          @emitChange()


module.exports = new EventStore
