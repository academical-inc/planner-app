
$         = require 'jquery'
DateUtils = require './DateUtils'


class EventUtils

  @concatExpandedEvents: (events, eventFactory)->
    events.reduce(
      (prevArr, event)->
        if event.expanded?
          if eventFactory?
            prevArr.concat event.expanded.map eventFactory
          else
            prevArr.concat event.expanded
        else
          event = eventFactory event if eventFactory?
          prevArr.concat [event]
      , []
    )

  @getSectionEvents: (sections)->
    sections.reduce(
      (prevArr, curSec)=>
        allSectionEvents = @concatExpandedEvents curSec.events, (ev)->
          section: curSec, event: ev
        prevArr.concat allSectionEvents
      , []
    )

  @expandEventThruWeek: (event, offset)->
    start = DateUtils.toUtcOffset event.startDt, offset
    end   = DateUtils.toUtcOffset event.endDt, offset
    if event.recurrence?
      event.expanded = event.recurrence.daysOfWeek.map (day)->
        dayNo     = DateUtils.getDayNo day
        e         = $.extend {}, true, event
        e.startDt = DateUtils.format start.day(dayNo)
        e.endDt   = DateUtils.format end.day(dayNo)
        e


module.exports = EventUtils
