
Humps      = require 'humps'
H          = require '../../SpecHelper'
EventUtils = require '../../../app/scripts/utils/EventUtils'

sections   = Humps.camelizeKeys require '../../fixtures/sections.json'


describe 'EventUtils', ->
  # TODO

  beforeEach ->
    @util = EventUtils
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
    @expandExp = [{id:"e1",n:"ex1"},{id:"e1",n:"ex2"},{id:"e2",n:"ex3"}]

  describe '.expandEvents', ->
    # TODO

  xdescribe '.concatExpandedEvents', ->
    # TODO Write according to new definition

    beforeEach ->
      @evFactory = H.spy "evFactory", retVal: (parent,e)->e

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
        expected = @events.notEx.map (e)-> [e, e]
        expect(@evFactory.calls.allArgs()).toEqual expected

      it 'returns correct concated events with correct ids when some expanded
      and some not', ->
        res = @util.concatExpandedEvents @events.mixed, @evFactory
        expect(res).toEqual @expandExp[0..1].concat [{id: "e2"}]
        expect(@evFactory.calls.count()).toEqual 3
        expect(@evFactory.calls.argsFor(0)).toContain @expandExp[0]
        expect(@evFactory.calls.argsFor(1)).toContain @expandExp[1]
        expect(@evFactory.calls.argsFor(2)).toEqual [{id: "e2"}, {id: "e2"}]


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

  describe '.expandThruWeek', ->

    it 'expands event and transforms utc', ->
      ev =
        name: "Event 1"
        startDt: "2015-01-01T08:00:00-05:00" # Thursday
        endDt:   "2015-01-01T09:00:00-05:00"
        recurrence:
          daysOfWeek: ["MO", "TH"]
          freq: "WEEKLY"
      expanded = @util.expandThruWeek(ev)
      expect(expanded.length).toEqual 3
      expect(expanded[0].startDt.format()).toEqual "2015-01-01T08:00:00-05:00"
      expect(expanded[0].endDt.format()).toEqual "2015-01-01T09:00:00-05:00"

    it 'does nothing if event does not have recurrence', ->
      ev =
        name: "Event2"
        startDt: "2015-01-01T13:00:00-05:00"
        endDt:   "2015-01-01T14:00:00-05:00"

      expanded = @util.expandThruWeek ev
      expect(expanded.length).toEqual 1
      expect(expanded[0]).toEqual ev
