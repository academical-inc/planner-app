
H                 = require '../../SpecHelper'
ColorPicker       = require '../../../app/scripts/components/ColorPicker'
ColorPalette      = require '../../../app/scripts/components/ColorPalette'
PersonalEventItem = require '../../../app/scripts/components/PersonalEventItem'


describe 'PersonalEventItem', ->

  describe '#render', ->

    beforeEach ->
      @data =
        id: '1'
        name: "event"
        color: "red"
      @handler = H.spy "handler"

    it 'renders state correctly', ->
      event   = H.render PersonalEventItem, item: @data
      heading = H.findWithClass event, "panel-heading"
      name    = H.scryWithTag(event, "a")[0]
      picker  = H.findWithType event, ColorPicker
      palette = H.findWithType event, ColorPalette

      colorsId = "personal-event-colors-#{@data.id}"

      expect(heading.props.id).toEqual "personal-event-heading-#{@data.id}"
      expect(name.props.children).toEqual @data.name
      expect(picker.props.colorPaletteId).toEqual colorsId
      expect(palette.props.id).toEqual colorsId

    it 'calls the on delete item callback correctly', ->
      event   = H.render PersonalEventItem,
        item: @data
        handleItemDelete: @handler
      deleteIcon = H.findWithClass event, "delete-icon"

      H.sim.click deleteIcon.getDOMNode()
      expect(@handler).toHaveBeenCalled()

