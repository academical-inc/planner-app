
H             = require '../../SpecHelper'
PanelItemList = require '../../../app/scripts/components/PanelItemList'


describe 'PanelItemList', ->

  describe '#render', ->

    assertAddButtonRendered = (list, props={})->
      addBtn = H.findWithTag list, "button"
      if props.handleItemAdd?
        expect(addBtn.props.onClick).toEqual props.handleItemAdd

      if props.itemAddDataToggle? and props.itemAddDataTarget?
        expect(addBtn.props["data-toggle"]).toEqual props.itemAddDataToggle
        expect(addBtn.props["data-target"]).toEqual props.itemAddDataTarget

    beforeEach ->
      @itemType = H.spy "itemType", retVal: "data"
      @defProps =
        itemType: @itemType
        initialState: [id: "item1", id: "item2"]

    it 'renders the list of items from state correctly', ->
      list     = H.render PanelItemList, @defProps
      expected = @defProps.initialState

      items = H.findWithClass(list, "panel-group").props.children
      expect(items.length).toEqual expected.length
      items.forEach (item, i)=>
        expect(item).toEqual "data"
        expect(@itemType.calls.argsFor(i)).toEqual [{
          key: expected[i].id
          item: expected[i]
        }]

    it 'does not render add button if required props not provided', ->
      list = H.render PanelItemList, @defProps
      expect(-> H.findWithClass("add-item-bar")).toThrowError()

      list = H.render PanelItemList, $.extend {}, @defProps,\
        itemAddDataToggle: "toggle-data"
      expect(-> H.findWithClass("add-item-bar")).toThrowError()

      list = H.render PanelItemList, $.extend {}, @defProps,\
        itemAddDataTarget: "target-data"
      expect(-> H.findWithClass("add-item-bar")).toThrowError()


    describe 'when handleItemAdd provided', ->

      beforeEach ->
        @itemAddHandler = H.spy "itemAddHandler"
        @props = $.extend {}, @defProps, handleItemAdd: @itemAddHandler
        @list  = H.render PanelItemList, @props

      it 'renders an add button', ->
        assertAddButtonRendered @list, @props

      it 'calls on click handler', ->
        button = H.findWithTag @list, "button"
        H.sim.click button.getDOMNode()
        expect(@itemAddHandler).toHaveBeenCalled()


    describe 'when itemAddDataToggle and itemAddDataTarget provided', ->

      it 'renders an add button correctly', ->
        props = $.extend {}, @defProps,
          itemAddDataToggle: "toggle-data"
          itemAddDataTarget: "target-data"
        list  = H.render PanelItemList, props
        assertAddButtonRendered list, props


