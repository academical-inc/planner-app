
H        = require '../../SpecHelper'
Dropdown = require '../../../app/scripts/components/Dropdown'


describe 'Dropdown', ->


  describe '#handleItemAdd', ->

    beforeEach ->
      @handler = H.spy "handler"
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: [{id: "i1", val: "v1"}]
        itemType: H.mockComponent()
        handleItemAdd: @handler
      @input = @dd.refs.itemName
      @input.getDOMNode().value = "  Value!  "
      @dd.handleItemAdd preventDefault: ->

    it 'calls provided handler with correct value', ->
      expect(@handler).toHaveBeenCalledWith "Value!"

    it 'clears input after adding', ->
      expect(@input.getDOMNode().value).toEqual ""


  describe '#handleItemSelected', ->

    beforeEach ->
      @item = val: "data"
      @handler = H.spy "handler"
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        handleItemSelected: @handler
        updateNameOnSelect: true
        items: []
        itemType: H.mockComponent()

    it 'calls handler set by parent in the props', ->
      @dd.handleItemSelected @item
      expect(@handler).toHaveBeenCalledWith @item

    it 'updates title correctly when property to do so is specified', ->
      H.spyOn @dd, "setState"
      @dd.handleItemSelected @item
      expect(@dd.setState).toHaveBeenCalledWith title: @item.val

    it 'does not update title when property to do so is not specified', ->
      @dd.props.updateNameOnSelect = undefined
      H.spyOn @dd, "setState"
      @dd.handleItemSelected @item
      expect(@dd.setState).not.toHaveBeenCalled()


  describe '#getItem', ->

    beforeEach ->
      @factory = H.spy "factory"
      @bindRet = ->
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: []
        itemType: @factory
        handleItemDelete: ->
      H.spyOn(@dd.handleItemSelected, "bind").and.returnValue @bindRet
      @item = {id: "k1", val: "v1"}

    it 'returns the correct item component', ->
      @dd.getItem @item
      expect(@factory).toHaveBeenCalledWith(
        key: @item.id
        item: @item
        onClick: @bindRet
        handleItemDelete: @dd.props.handleItemDelete
      )
      expect(@dd.handleItemSelected.bind).toHaveBeenCalledWith @dd, @item


  describe '#renderItems', ->

    beforeEach ->
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: []
        itemType: H.mockComponent()
      H.spyOn @dd, "getItem"

    it 'renders dropdown items correctly when headers present', ->
      data = [
        {id: "k1", val: "v1"}
        {header: "h1", items: [{id: "k2", val: "v2"}, {id: "k3", val: "v3"}]}
        {id: "k4", val: "v4"}
      ]
      items = @dd.renderItems data

      expect(items.length).toEqual 6
      expect(items[1].props.children).toEqual "h1"
      expect(items[4].props.className).toEqual "divider"
      expect(@dd.getItem.calls.allArgs()).toEqual [
        [data[0]]
        [data[1].items[0]]
        [data[1].items[1]]
        [data[2]]
      ]

    it 'renders dropdown items correctly when only headers present', ->
      data = [
        {header: "h1", items: [{id: "k1", val: "v1"}]}
        {header: "h2", items: [{id: "k2", val: "v2"}]}
      ]
      items = @dd.renderItems data
      expect(items.length).toEqual 5
      d = 0
      for i in [0, 3]
        expect(items[i].props.children).toEqual data[d].header
        # Don't render last divider:
        expect(items[i+2].props.className).toEqual "divider" if d == 0
        d += 1
      expect(@dd.getItem.calls.allArgs()).toEqual [
        [data[0].items[0]]
        [data[1].items[0]]
      ]

    it 'renders dropdown items correctly when no headers present', ->
      data = [
        {id: "k1", val: "v1"}
        {id: "k2", val: "v2"}
      ]
      items = @dd.renderItems data
      expect(items.length).toEqual 2
      expect(@dd.getItem.calls.allArgs()).toEqual [
        [data[0]]
        [data[1]]
      ]


  describe '#render', ->

    beforeEach ->
      @props =
        rootTag: H.mockComponent()
        items: [{id: "k1", val: "v1"}, {id: "k2", val: "v2"}]
        itemType: H.mockComponent()
        title: "title"
        className: "klass"

    it 'renders state and props correctly', ->
      root = H.mockComponent()
      dd = H.render Dropdown, @props

      ddNode = dd.getDOMNode()
      expect(ddNode.tagName.toLowerCase()).toEqual root.type
      expect(ddNode.getAttribute("class")).toContain "klass"
      expect(ddNode.getAttribute("class")).toContain "dropdown"

      toggle = H.findWithClass dd, "dropdown-toggle"
      expect(toggle.props.children[0]).toEqual "title"

      ul = H.findWithTag dd, "ul"
      expect(ul.props.children.length).toEqual 2

    it 'renders add input as final item when add item handler provided', ->
      @props.handleItemAdd = ->
      @props.addItemPlaceholder = "Add custom item"
      dd = H.render Dropdown, @props

      ul = H.findWithTag dd, "ul"
      children = ul.props.children
      expect(children.length).toEqual 4
      expect(children[2].key).toEqual "add-divider"
      expect(H.findWithTag(ul, "input").props.placeholder).toEqual(
        @props.addItemPlaceholder
      )
      expect(H.findWithTag(ul, "form").props.onSubmit).toEqual(
        dd.handleItemAdd
      )

    it 'calls item add handler when provided', ->
      handler = H.spy "handler"
      @props.handleItemAdd = handler
      dd = H.render Dropdown, @props

      form = H.findWithTag dd, "form"
      H.sim.submit form.getDOMNode()
      expect(handler).toHaveBeenCalled()


