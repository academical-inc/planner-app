

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


module.exports = EventUtils
