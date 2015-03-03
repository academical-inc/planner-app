
H            = require '../../SpecHelper'
SectionUtils = require '../../../app/scripts/utils/SectionUtils'

sections     = require '../../fixtures/sections.json'


describe 'SectionUtils', ->

  describe '#getSectionEvents', ->

    beforeEach ->
      @util = SectionUtils

    it 'returns correct events when 1 section with only 1 recurring event', ->
      events = @util.getSectionEvents [sections[0]]
      expect(events.length).toEqual sections[0].events[0].expanded.length
      events.forEach (event, i)=>
        expect(event.event).toEqual sections[0].events[0].expanded[i]
        expect(event.section).toEqual sections[0]

    it 'returns correct events when 1 section with > 1 recurring event', ->
      events = @util.getSectionEvents [sections[1]]
      expect(events.length).toEqual 6
      events.forEach (event, i)=>
        if i is 0 or i is 1
          expect(event.event).toEqual sections[1].events[0].expanded[i]
        else if i is 2 or i is 3
          expect(event.event).toEqual sections[1].events[1].expanded[i-2]
        else
          expect(event.event).toEqual sections[1].events[2].expanded[i-4]
        expect(event.section).toEqual sections[1]

    it 'returns correct events when many sections provided', ->
      events = @util.getSectionEvents sections
      firstLength = sections[0].events[0].expanded.length
      expect(events.length).toEqual firstLength + 6
      for event, i in events[0...firstLength]
        expect(event.event).toEqual sections[0].events[0].expanded[i]
        expect(event.section).toEqual sections[0]

      for event, i in events[firstLength...firstLength+6]
        if i is 0 or i is 1
          expect(event.event).toEqual sections[1].events[0].expanded[i]
        else if i is 2 or i is 3
          expect(event.event).toEqual sections[1].events[1].expanded[i-2]
        else
          expect(event.event).toEqual sections[1].events[2].expanded[i-4]
        expect(event.section).toEqual sections[1]
