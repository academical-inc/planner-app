
H               = require '../../SpecHelper'
ScheduleInfoBar = require '../../../app/scripts/components/ScheduleInfoBar'
PanelItemList   = require '../../../app/scripts/components/PanelItemList'


describe 'ScheduleInfoBar', ->

  describe '#handlePersonalEventAdd', ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @modalSelector = ".modal-selector"
      @restore = H.rewire ScheduleInfoBar,
        selectors: PERSONAL_EVENT_MODAL: @modalSelector
        $: @mock$

    afterEach ->
      @restore()

    it 'should open the modal for personal event form', ->
      bar = H.render ScheduleInfoBar
      bar.handlePersonalEventAdd()
      expect(@mock$).toHaveBeenCalledWith @modalSelector
      expect(@mock$El.modal).toHaveBeenCalledWith "show"

  describe '#render', ->

    beforeEach ->
      @sectionItem   = ->
      @eventItem     = ->
      @restore = H.rewire ScheduleInfoBar,
        SectionItem: @sectionItem
        PersonalEventItem: @eventItem

      @data =
        totalCredits: 6
        totalSections: 2
        sections: [ {id: "s1"}, {id: "s2"} ]
        personalEvents: [ {id: "p1"}, {id: "p2"} ]


    afterEach ->
      @restore

    assertRenderedState = (lists, data, sectionItem, eventItem)->
      expect(lists.length).toEqual 2

      sections = lists[0]
      expect(sections.props.itemType).toEqual sectionItem
      expect(sections.props.header).toContain data.totalSections
      expect(sections.props.header).toContain data.totalCredits
      expect(sections.props.items).toEqual data.sections

      events = lists[1]
      expect(events.props.itemType).toEqual eventItem
      expect(events.props.items).toEqual data.personalEvents

    it 'renders correctly based on initial state', ->
      bar   = H.render ScheduleInfoBar, initialState: @data
      lists = H.scryWithType bar, PanelItemList
      assertRenderedState lists, @data, @sectionItem, @eventItem

    it 'updates correctly when state is updated', ->
      bar   = H.render ScheduleInfoBar
      bar.setState @data, =>
        lists = H.scryWithType bar, PanelItemList
        assertRenderedState lists, @data, @sectionItem, @eventItem

