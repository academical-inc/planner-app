
H            = require '../../SpecHelper'
WeekCalendar = require '../../../app/scripts/components/WeekCalendar'


sections     = require '../../fixtures/sections.json'


describe 'WeekCalendar', ->

  describe '#componentDidMount', ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @mockSectionStore = H.spyObj "SectionStore",
        ["addChangeListener", "removeChangeListener"]
      @restore = H.rewire WeekCalendar,
        $: @mock$
        SectionStore: @mockSectionStore
      @cal = H.render WeekCalendar

    afterEach ->
      @restore

    it 'should initialize the fullcalendar plugin', ->
      expect(@mock$).toHaveBeenCalledWith(@cal.getDOMNode())
      expect(@mock$El.fullCalendar).toHaveBeenCalled()

    it 'should subscribe to stores', ->
      expect(@mockSectionStore.addChangeListener).toHaveBeenCalledWith \
        @cal.onSectionsChange

  describe '#componentWillUnmount', ->

    beforeEach ->
      @mockSectionStore = H.spyObj "SectionStore",
        ["addChangeListener", "removeChangeListener"]
      @restore = H.rewire WeekCalendar,
        SectionStore: @mockSectionStore
      @cal = H.render WeekCalendar

    afterEach ->
      @restore

    it 'unsubscribes from stores', ->
      @cal.componentWillUnmount()
      expect(@mockSectionStore.removeChangeListener).toHaveBeenCalledWith \
        @cal.onSectionsChange


  describe '#getSectionEvents', ->

    beforeEach ->
      @cal = H.render WeekCalendar

    it 'returns correct events when 1 section with only 1 recurring event', ->
      events = @cal.getSectionEvents [sections[0]]
      expect(events.length).toEqual sections[0].events[0].expanded.length
      events.forEach (event, i)=>
        expect(event.event).toEqual sections[0].events[0].expanded[i]
        expect(event.section).toEqual sections[0]

    it 'returns correct events when 1 section with > 1 recurring event', ->
      events = @cal.getSectionEvents [sections[1]]
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
      events = @cal.getSectionEvents sections
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


  describe '#sectionEventDataTransform', ->

    beforeEach ->
      @cal = H.render WeekCalendar
      @sec = sections[0]
      @ev  = @sec.events[0].expanded[0]
      @secEvData =
        section: @sec
        event: @ev

    it 'transforms section event data into a fullcalendar event', ->
      res = @cal.sectionEventDataTransform @secEvData
      expect(res).toEqual(
        id: @sec.id
        title: @sec.courseName
        description: @sec.courseDescription
        start: @ev.startDt
        end: @ev.endDt
        location: @ev.location
        editable: false
        allDay: false
      )

