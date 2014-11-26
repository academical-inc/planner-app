
H           = require '../../SpecHelper'
SectionItem = require '../../../app/scripts/components/SectionItem'


describe 'SectionItem', ->

  beforeEach ->
    @data =
      id: "5fb6679adb55"
      sectionId:  "45578"
      sectionNumber: 2
      courseName: "Algebra"
      courseCode: "MATE1203"
      seats:
        available: 20
      teacherNames: ["Dimitri Alejo", "Juan Tejada"]
      credits: 3
      departments: [{name: "Math Department"}]
      color: "#fff"


  describe '#getSeatsColorClass', ->

    seats = (seats, data)->
      H.$.extend(true, {}, data, seats: available: seats)

    beforeEach ->
      @restore = H.rewire SectionItem,
        seatsMap:
          UPPER: bound: 50, className: "upper"
          LOWER: bound: 15, className: "lower"
          ZERO:  className: "zero"

    afterEach ->
      @restore()

    it 'returns correct css class when seats available is >= upper bound ', ->
      item = H.render SectionItem, item: seats(50, @data)
      expect(item.getSeatsColorClass()).toEqual "upper"

      item = H.render SectionItem, item: seats(60, @data)
      expect(item.getSeatsColorClass()).toEqual "upper"

    it 'returns correct css class when seats available is < upper bound and
        >= lower bound', ->
      item = H.render SectionItem, item: seats(15, @data)
      expect(item.getSeatsColorClass()).toEqual "lower"

      item = H.render SectionItem, item: seats(20, @data)
      expect(item.getSeatsColorClass()).toEqual "lower"

    it 'returns correct css class when seats available is < lower bound ', ->
      item = H.render SectionItem, item: seats(14, @data)
      expect(item.getSeatsColorClass()).toEqual "zero"

      item = H.render SectionItem, item: seats(0, @data)
      expect(item.getSeatsColorClass()).toEqual "zero"

      item = H.render SectionItem, item: seats(-3, @data)
      expect(item.getSeatsColorClass()).toEqual "zero"


  describe '#render', ->

    assertRenderedState = (item, data)->
      contentId = "section-info-#{data.id}"
      colorId   = "section-colors-#{data.id}"

      heading   = H.findWithClass item, "panel-heading"
      trigger   = H.findWithTag heading, "a"
      content   = H.findWithClass item, "panel-collapse"
      info_list = H.scryWithClass item, "list-group-item"

      expect(heading.props.style.borderColor).toEqual data.color

      expect(trigger.props.href).toEqual "##{contentId}"
      expect(trigger.props["data-toggle"]).toEqual "collapse"
      expect(trigger.props.children).toEqual "#{data.courseCode} -
        #{data.courseName}"

      expect(content.props.id).toEqual contentId
      expect(content.props.style.borderColor).toEqual data.color

      expect(info_list[0].props.children).toContain data.seats.available
      expect(info_list[1].props.children).toEqual data.teacherNames.join(", ")

      expect(info_list[2].props.children).toContain data.credits
      expect(info_list[2].props.children).toContain data.sectionNumber
      expect(info_list[2].props.children).toContain data.sectionId

      final = info_list[3].props.children
      expect(final[0].props.children).toContain data.departments[0].name
      expect(final[1].props.colorPaletteId).toEqual colorId
      expect(final[2].props.id).toEqual colorId


    beforeEach ->
      @restore = H.rewire SectionItem,
        ColorPicker: H.mockComponent()
        ColorPalette: H.mockComponent()

    afterEach ->
      @restore

    it 'renders correctly based on state', ->
      item = H.render SectionItem, item: @data
      assertRenderedState item, @data

    it 'calls the on delete item callback correctly', ->
      handler = H.spy "handler"
      item = H.render SectionItem, item: @data, handleItemDelete: handler
      deleteIcon = H.findWithClass item, "delete-icon"

      H.sim.click deleteIcon.getDOMNode()
      expect(handler).toHaveBeenCalledWith @data

