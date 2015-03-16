
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
          {id: "e1", expanded: [{id: "ex1", n:"ex1"}, {id: "ex2", n:"ex2"}]}
          {id: "e2", expanded: [{id: "ex3", n:"ex3"}]}
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
      @expandExp = [{id:"e1",n:"ex1"},{id:"e1",n:"ex2"},{id:"e2",n:"ex3"}]

    describe 'when event factory provided', ->

      it 'returns correct concated events with correct ids when they are all
      expanded', ->
        res = @util.concatExpandedEvents @events.expanded, @evFactory
        expect(res).toEqual @expandExp
        for e, idx in @expandExp
          expect(@evFactory.calls.argsFor(idx)).toContain e

      it 'returns correct concated events with correct ids when they are not
      expanded', ->
        res = @util.concatExpandedEvents @events.notEx, @evFactory
        expect(res).toEqual @events.notEx
        expected = @events.notEx.map (e)-> [e]
        expect(@evFactory.calls.allArgs()).toEqual expected

      it 'returns correct concated events with correct ids when some expanded
      and some not', ->
        res = @util.concatExpandedEvents @events.mixed, @evFactory
        expect(res).toEqual @expandExp[0..1].concat [{id: "e2"}]
        expect(@evFactory.calls.count()).toEqual 3
        expect(@evFactory.calls.argsFor(0)).toContain @expandExp[0]
        expect(@evFactory.calls.argsFor(1)).toContain @expandExp[1]
        expect(@evFactory.calls.argsFor(2)).toEqual [{id: "e2"}]


    describe 'when event factory not provided', ->

      it 'returns correct concated events with correct ids when they are all
      expanded', ->
        res = @util.concatExpandedEvents @events.expanded
        expect(res).toEqual @expandExp

      it 'returns correct concated events with correct ids when they are not
      expanded', ->
        res = @util.concatExpandedEvents @events.notEx
        expect(res).toEqual @events.notEx

      it 'returns correct concated events with correct ids when some expanded
      and some not', ->
        res = @util.concatExpandedEvents @events.mixed
        expect(res).toEqual @expandExp[0..1].concat [{id: "e2"}]


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


  describe '.expandEventThruWeek', ->

    it 'expands event and transforms utc', ->
      ev =
        name: "Event 1"
        startDt: "2015-01-01T13:00:00+00:00"
        endDt:   "2015-01-01T14:00:00+00:00"
        recurrence:
          daysOfWeek: ["MO", "TH"]
      @util.expandEventThruWeek(ev, -300)
      expect(ev.expanded.length).toEqual 2
      expect(ev.expanded[0].name).toEqual "Event 1"
      expect(ev.expanded[0].startDt).toEqual "2014-12-29T08:00:00-05:00"
      expect(ev.expanded[0].endDt).toEqual "2014-12-29T09:00:00-05:00"
      expect(ev.expanded[1].name).toEqual "Event 1"
      expect(ev.expanded[1].startDt).toEqual "2015-01-01T08:00:00-05:00"
      expect(ev.expanded[1].endDt).toEqual "2015-01-01T09:00:00-05:00"

    it 'does nothing if event does not have recurrence', ->
      ev =
        name: "Event2"
        startDt: "2015-01-01T13:00:00+00:00"
        endDt:   "2015-01-01T14:00:00+00:00"

      @util.expandEventThruWeek(ev, -300)
      expect(ev.expanded).toBeUndefined()
