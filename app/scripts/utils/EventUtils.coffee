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

$      = require 'jquery'
Moment = require 'moment'
_      = require './DateUtils'


# TODO Test
beforeOrSame = (dt1, dt2)->
  dt1.isBefore(dt2) or dt1.isSame(dt2)

eachForWeek = (startDt, endDt, untilDt, days, cb)->
  [1..7].forEach ->
    day = if startDt.day() is 0 then 7 else startDt.day()
    day = _.getDayStr(day)
    if days.indexOf(day) != -1 and beforeOrSame(startDt, untilDt)
      cb startDt.clone(), endDt.clone()
    startDt.add 1, 'd'
    endDt.add 1, 'd'

eachUntil = (startDt, endDt, untilDt, incr, cb)->
  startDt = _.date startDt
  endDt   = _.date endDt
  untilDt = _.date untilDt
  while beforeOrSame(startDt, untilDt)
    cb startDt.clone(), endDt.clone()
    startDt.add 1, incr
    endDt.add 1, incr

generateDates = (event, freq, untilDt, days, cb)->
  incr = 'w'  # Always weekly here

  if freq is "WEEKLY" and days?
    eachUntil event.startDt, event.endDt, untilDt, incr, (startDt, endDt)->
      eachForWeek startDt, endDt, untilDt, days, cb

expandEvent = (parent, event, {freq, days, untilDt}={}, cb)->
  expanded = []
  if event.recurrence?
    freq ?= event.recurrence.freq
    days ?= event.recurrence.daysOfWeek
    untilDt ?= event.recurrence.repeatUntil

    generateDates event, freq, untilDt, days, (sdt, edt)->
      expanded.push {
        parent: parent
        startDt: sdt
        endDt: edt
        timezone: event.timezone
        location: event.location
      }
  else
    expanded.push event
  expanded

# TODO Test
class EventUtils

  @expandEvents: (parent, events)->
    events.reduce(
      (mem, event)->
        mem.concat expandEvent(parent, event)
      , []
    )

  @concatEvents: (objs)->
    objs.reduce(
      (mem, obj)->
        mem.concat(obj.events or [])
      , []
    )

  @concatExpandedEvents: (objs)->
    objs.reduce(
      (mem, obj)->
        mem.concat(obj.expanded or [])
      , []
    )

  @expandThruWeek: (event, dates={})->
    event = $.extend true, {}, event, dates
    untilDt = _.date(event.startDt).add 1, 'w'
    expandEvent event, event, untilDt: untilDt

module.exports = EventUtils
