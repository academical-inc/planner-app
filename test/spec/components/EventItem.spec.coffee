
H            = require '../../SpecHelper'
ColorPicker  = require '../../../app/scripts/components/ColorPicker'
ColorPalette = require '../../../app/scripts/components/ColorPalette'
EventItem    = require '../../../app/scripts/components/EventItem'


describe 'EventItem', ->

  describe '#render', ->

    beforeEach ->
      @data =
        id: '1'
        name: "event"
        color: "red"
      @handler = H.spy "handler"

    it 'renders state correctly', ->
      event   = H.render EventItem, item: @data
      heading = H.findWithClass event, "panel-heading"
      name    = H.scryWithTag(event, "a")[0]
      picker  = H.findWithType event, ColorPicker
      palette = H.findWithType event, ColorPalette

      colorsId = "event-colors-#{@data.id}"

      expect(heading.props.id).toEqual "event-heading-#{@data.id}"
      expect(name.props.children).toEqual @data.name
      expect(picker.props.colorPaletteId).toEqual colorsId
      expect(palette.props.id).toEqual colorsId

    it 'calls the on delete item callback correctly', ->
      event   = H.render EventItem,
        item: @data
        handleItemDelete: @handler
      deleteIcon = H.findWithClass event, "delete-icon"

      H.sim.click deleteIcon.getDOMNode()
      expect(@handler).toHaveBeenCalledWith @data

