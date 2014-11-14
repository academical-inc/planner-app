
H               = require '../../SpecHelper'
ScheduleInfoBar = require '../../../app/scripts/components/ScheduleInfoBar'
PanelItemList   = require '../../../app/scripts/components/PanelItemList'


describe 'ScheduleInfoBar', ->

  describe '#render', ->

    beforeEach ->
      @modalSelector = ".modal-selector"
      @sectionItem   = ->
      @eventItem = ->
      @restore = H.rewire ScheduleInfoBar,
        C: selectors: PERSONAL_EVENT_MODAL: @modalSelector
        SectionItem: @sectionItem
        PersonalEventItem: @eventItem

      @data =
        totalCredits: 6
        totalSections: 2
        sections: [ {id: "s1"}, {id: "s2"} ]
        personalEvents: [ {id: "p1"}, {id: "p2"} ]

      @sectionsHeader = "Sections: #{@data.totalSections} Credits:
                        #{@data.totalCredits}"

    afterEach ->
      @restore

    assertRenderedState = (lists, data, sectionItem, sectionsHeader,\
        eventItem, modalSelector)->
      expect(lists.length).toEqual 2

      sections = lists[0]
      expect(sections.props.itemType).toEqual sectionItem
      expect(sections.props.header).toEqual sectionsHeader
      expect(sections.props.initialState).toEqual data.sections

      events = lists[1]
      expect(events.props.itemType).toEqual eventItem
      expect(events.props.itemAddDataToggle).toEqual "modal"
      expect(events.props.itemAddDataTarget).toEqual modalSelector
      expect(events.props.initialState).toEqual data.personalEvents

    it 'renders correctly based on initial state', ->
      bar   = H.render ScheduleInfoBar, initialState: @data
      lists = H.scryWithType bar, PanelItemList
      assertRenderedState lists, @data, @sectionItem, @sectionsHeader,\
        @eventItem, @modalSelector

    it 'updates correctly when state is updated', ->
      bar   = H.render ScheduleInfoBar
      bar.setState @data, =>
        lists = H.scryWithType bar, PanelItemList
        assertRenderedState lists, @data, @sectionItem, @sectionsHeader,\
          @eventItem, @modalSelector

