
Humps        = require 'humps'
H            = require '../../SpecHelper'
WeekCalendar = require '../../../app/scripts/components/WeekCalendar'

sections     = Humps.camelizeKeys require '../../fixtures/sections.json'


describe 'WeekCalendar', ->


  describe '#componentDidMount', ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire WeekCalendar,
        $: @mock$
      @cal = H.render WeekCalendar

    afterEach ->
      @restore

    it 'should initialize the fullcalendar plugin', ->
      expect(@mock$).toHaveBeenCalledWith(@cal.getDOMNode())
      expect(@mock$El.fullCalendar).toHaveBeenCalled()


  describe '#sectionEventDataTransform', ->

    beforeEach ->
      @sec = sections[0]
      @ev  = @sec.events[0].expanded[0]
      @ev.parent = @sec
      @restore = H.rewire WeekCalendar,
        "_sectionColors": =>
          colors = {}
          colors[@sec.id] = "red"
          colors
      @cal = H.render WeekCalendar

    it 'transforms section event data into a fullcalendar event', ->
      res = @cal.sectionEventDataTransform @ev
      expect(res).toEqual(
        id: @sec.id
        title: @sec.courseName
        description: @sec.courseDescription
        start: @ev.startDt
        end: @ev.endDt
        location: @ev.location
        backgroundColor: "red"
        borderColor: "red"
        editable: false
        allDay: false
        isSection: true
      )

