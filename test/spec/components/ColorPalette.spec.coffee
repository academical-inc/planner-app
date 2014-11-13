
H            = require '../../SpecHelper'
ColorPalette = require '../../../app/scripts/components/ColorPalette'


describe "ColorPalette", ->

  describe "#render", ->

    beforeEach ->
      @restore = H.rewire ColorPalette, colors: ["#fff", "#000"]
      @handler = H.spy "handler"
      @palette = H.render ColorPalette, handleColorSelect: @handler
      @colors = H.scryWithClass @palette, "color"

    afterEach ->
      @restore()

    it 'should render the provided colors correctly', ->
      expect(@colors.length).toEqual 2
      expect(@colors[0].getDOMNode().dataset.color).toEqual "#fff"
      expect(@colors[1].getDOMNode().dataset.color).toEqual "#000"

    it 'should call the callback correctly', ->
      colorNode = @colors[0].getDOMNode()
      H.sim.click colorNode
      expect(@handler).toHaveBeenCalled()

