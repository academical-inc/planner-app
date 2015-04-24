
H            = require '../../SpecHelper'
ScheduleItem = require '../../../app/scripts/components/ScheduleItem'


describe 'ScheduleItem', ->

  describe '#render', ->

    beforeEach ->
      @clickHandler = H.spy "clickHandler"
      @deleteHandler = H.spy "deleteHandler"
      @props =
        item: name: "Schedule"
        onClick: @clickHandler
        handleItemDelete: @deleteHandler

    it 'renders properties correctly', ->
      item = H.render ScheduleItem, @props
      anchor = H.findWithTag item, "a"

      expect(item.props.onClick).toEqual @props.onClick
      expect(anchor.props.children[0]).toEqual @props.item.name

    it 'renders spinner when item (schedule) is for delete', ->
      @props.item.del = true
      item = H.render ScheduleItem, @props
      icon = H.findWithTag item, "i"

      expect(item.props.onClick).toEqual @props.onClick
      expect(icon.props.className).toContain "spinner"

    it 'renders delete icon when item (schedule) is not for delete', ->
      item = H.render ScheduleItem, @props
      icon = H.findWithTag item, "img"

      expect(item.props.onClick).toEqual @props.onClick
      expect(icon.props.className).toContain "delete"

    it 'calls on click handler correctly', ->
      item = H.render ScheduleItem, @props
      H.sim.click item.getDOMNode()
      expect(@clickHandler).toHaveBeenCalled()
      expect(@deleteHandler).not.toHaveBeenCalled()

    it 'calls item delete handler correctly', ->
      item = H.render ScheduleItem, @props
      icon = H.findWithTag item, "img"
      H.sim.click icon.getDOMNode()
      expect(@deleteHandler).toHaveBeenCalledWith @props.item
      expect(@clickHandler).not.toHaveBeenCalled()


