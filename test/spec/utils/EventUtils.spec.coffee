
H          = require '../../SpecHelper'
EventUtils = require '../../../app/scripts/utils/EventUtils'

sections   = require '../../fixtures/sections.json'


describe 'EventUtils', ->

  beforeEach ->
    @util = EventUtils

  describe '.concatExpandedEvents', ->

    beforeEach ->
      @events =
        expanded: [
          {id: "e1", expanded: ["ex1", "ex2"]}
          {id: "e2", expanded: ["ex3", "ex4"]}
        ]
        notEx: [
          {id: "e1"}
          {id: "e2"}
        ]
      @events.mixed = [
        @events.expanded[0]
        @events.notEx[1]
      ]
      @evFactory = H.spy "evFactory", retVal: (e)->e
      @expandExp = ["ex1", "ex2", "ex3", "ex4" ]

    describe 'when event factory provided', ->

      it 'returns correct concated events when they are all expanded', ->
        res = @util.concatExpandedEvents @events.expanded, @evFactory
        expect(res).toEqual @expandExp
        for e, idx in @expandExp
          expect(@evFactory.calls.argsFor(idx)).toContain e

      it 'returns correct concated events when they are not expanded', ->
        res = @util.concatExpandedEvents @events.notEx, @evFactory
        expect(res).toEqual @events.notEx
        expected = @events.notEx.map (e)-> [e]
        expect(@evFactory.calls.allArgs()).toEqual expected

      it 'returns correct concated events when some expanded and some not', ->
        res = @util.concatExpandedEvents @events.mixed, @evFactory
        expect(res).toEqual ["ex1", "ex2", {id: "e2"}]
        expect(@evFactory.calls.count()).toEqual 3
        expect(@evFactory.calls.argsFor(0)).toContain "ex1"
        expect(@evFactory.calls.argsFor(1)).toContain "ex2"
        expect(@evFactory.calls.argsFor(2)).toEqual [{id: "e2"}]


    describe 'when event factory not provided', ->

      it 'returns correct concated events when they are all expanded', ->
        res = @util.concatExpandedEvents @events.expanded
        expect(res).toEqual @expandExp

      it 'returns correct concated events when they are not expanded', ->
        res = @util.concatExpandedEvents @events.notEx
        expect(res).toEqual @events.notEx

      it 'returns correct concated events when some expanded and some not', ->
        res = @util.concatExpandedEvents @events.mixed
        expect(res).toEqual ["ex1", "ex2", {id: "e2"}]


  describe '.getSectionEvents', ->


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
