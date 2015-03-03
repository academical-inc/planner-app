
H            = require '../../SpecHelper'
WeekCalendar = require '../../../app/scripts/components/WeekCalendar'

sections     = require '../../fixtures/sections.json'


describe 'WeekCalendar', ->

  beforeEach ->
    @mockSectionStore = H.spyObj "SectionStore",
      ["addChangeListener", "removeChangeListener"]
    @mockPreviewStore = H.spyObj "PreviewStore",
      ["addChangeListener", "removeChangeListener"]


  describe '#componentDidMount', ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire WeekCalendar,
        $: @mock$
        SectionStore: @mockSectionStore
        PreviewStore: @mockPreviewStore
      @cal = H.render WeekCalendar

    afterEach ->
      @restore

    it 'should initialize the fullcalendar plugin', ->
      expect(@mock$).toHaveBeenCalledWith(@cal.getDOMNode())
      expect(@mock$El.fullCalendar).toHaveBeenCalled()

    it 'should subscribe to stores', ->
      expect(@mockSectionStore.addChangeListener).toHaveBeenCalledWith \
        @cal.onSectionsChange
      expect(@mockPreviewStore.addChangeListener).toHaveBeenCalledWith \
        @cal.onPreviewChange


  describe '#componentWillUnmount', ->

    beforeEach ->
      @restore = H.rewire WeekCalendar,
        SectionStore: @mockSectionStore
        PreviewStore: @mockPreviewStore

    afterEach ->
      @restore

    it 'unsubscribes from stores', ->
      cal = H.render WeekCalendar
      cal.componentWillUnmount()
      expect(@mockSectionStore.removeChangeListener).toHaveBeenCalledWith \
        cal.onSectionsChange
      expect(@mockPreviewStore.removeChangeListener).toHaveBeenCalledWith \
        cal.onPreviewChange


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
        start: @ev.startDt
        end: @ev.endDt
        location: @ev.location
        editable: false
        allDay: false
        isSection: true
      )

