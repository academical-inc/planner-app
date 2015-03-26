
$         = require 'jquery'
DateUtils = require './DateUtils'


class EventUtils

  @concatExpandedEvents: (events, eventFactory)->
    events.reduce(
      (prevArr, event)->
        if event.expanded?
          prevArr.concat event.expanded.map ->
            arguments[0].id = event.id
            if eventFactory?
              eventFactory event, arguments...
            else
              arguments[0]
        else
          event = eventFactory null, event if eventFactory?
          prevArr.concat [event]
      , []
    )

  @getScheduleEvents: (events)->
    @concatExpandedEvents events, (parent, ev)->
      parent: parent, ev: ev

  @getSectionEvents: (sections)->
    sections.reduce(
      (prevArr, curSec)=>
        allSectionEvents = @concatExpandedEvents curSec.events, (parent, ev)->
          section: curSec, event: ev
        prevArr.concat allSectionEvents
      , []
    )

  @expandEventThruWeek: (event, {startDt, endDt}={})->
    startDt ?= event.startDt
    endDt   ?= event.endDt
    if event.recurrence?
      event.expanded = event.recurrence.daysOfWeek.map (day)->
        dayNo = DateUtils.getDayNo day
        startDt: DateUtils.format DateUtils.setDay(startDt, dayNo)
        endDt: DateUtils.format DateUtils.setDay(endDt, dayNo)


module.exports = EventUtils
