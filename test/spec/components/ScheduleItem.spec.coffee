
H            = require '../../SpecHelper'
ScheduleItem = require '../../../app/scripts/components/ScheduleItem'


describe 'ScheduleItem', ->

  describe '#render', ->

    beforeEach ->
      @clickHandler = H.spy "clickHandler"
      @deleteHandler = H.spy "deleteHandler"
      @props =
        item: name: "item-val"
        onClick: @clickHandler
        handleItemDelete: @deleteHandler
      @item = H.render ScheduleItem, @props

    it 'renders properties correctly', ->
      anchor = H.findWithTag @item, "a"
      icon = H.findWithTag @item, "i"

      expect(@item.props.onClick).toEqual @props.onClick
      expect(anchor.props.children[0]).toEqual @props.item.val

    it 'calls on click handler correctly', ->
      H.sim.click @item.getDOMNode()
      expect(@clickHandler).toHaveBeenCalled()
      expect(@deleteHandler).not.toHaveBeenCalled()

    it 'calls item delete handler correctly', ->
      icon = H.findWithTag @item, "i"
      H.sim.click icon.getDOMNode()
      expect(@deleteHandler).toHaveBeenCalledWith @props.item
      expect(@clickHandler).not.toHaveBeenCalled()


