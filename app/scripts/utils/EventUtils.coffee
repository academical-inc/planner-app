
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

class EventUtils

  @expandEvents: (parent, events)->
    events.reduce(
      (mem, event)->
        mem.concat expandEvent(parent, event)
      , []
    )

  @concatExpandedEvents: (objs)->
    objs.reduce(
      (mem, obj)->
        mem.concat(obj.expanded or [])
      , []
    )

  @expandThruWeek: (event)->
    untilDt = _.date(event.startDt).add 1, 'w'
    expandEvent event, event, untilDt: untilDt

module.exports = EventUtils
