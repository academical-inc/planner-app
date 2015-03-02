

class SectionUtils

  @getSectionEvents: (sections)->
    sections.reduce(
      (prevArr, curSec)->
        allSectionEvents = curSec.events.reduce(
          (prevEvArr, ev)->
            prevEvArr.concat ev.expanded.map (e)->
              section: curSec, event: e
          , []
        )
        prevArr.concat allSectionEvents
      , []
    )


module.exports = SectionUtils
