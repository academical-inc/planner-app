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

EventFactory      = require '../factories/EventFactory'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{saveSchedule}    = require './ScheduleActions'


class EventActions

  @addEvent: (name, startDt, endDt, days, repeatUntil, color)->
    event = EventFactory.create
      name: name
      startDt: startDt
      endDt: endDt
      color: color
      recurrence:
        daysOfWeek: days
        repeatUntil: repeatUntil
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.ADD_EVENT
      event: event
    saveSchedule()

  @updateEvent: (eventId, startDt, endDt, dayDelta)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.UPDATE_EVENT
      event:
        id: eventId
        startDt: startDt
        endDt: endDt
        dayDelta: dayDelta
    saveSchedule()

  @changeEventColor: (eventId, color)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CHANGE_EVENT_COLOR
      eventId: eventId
      color: color
    saveSchedule()

  @removeEvent: (eventId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.REMOVE_EVENT
      eventId: eventId
    saveSchedule()


module.exports = EventActions
