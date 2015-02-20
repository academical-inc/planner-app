
H        = require '../../SpecHelper'
Dropdown = require '../../../app/scripts/components/Dropdown'


describe 'Dropdown', ->


  describe '#handleItemAdd', ->

    beforeEach ->
      @handler = H.spy "handler"
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: []
        itemType: H.mockComponent()
        handleItemAdd: @handler

    describe 'when item name value provided', ->

      beforeEach ->
        @input = @dd.refs.itemName.getDOMNode()
        @input.value = "  Value!  "
        @dd.handleItemAdd preventDefault: ->

      it 'calls provided handler with correct value', ->
        expect(@handler).toHaveBeenCalledWith "Value!"

      it 'clears input after adding', ->
        expect(@input.value).toEqual ""

      it 'input form group does not have error class', ->
        expect(@dd.refs.inputFormGroup.getDOMNode().className).not.toContain \
          "has-error"

    describe 'when item name value provided', ->

      beforeEach ->
        @dd.handleItemAdd preventDefault: ->

      it 'does not call callback', ->
        expect(@handler).not.toHaveBeenCalled()

      it 'adds error class to form group', ->
        expect(@dd.refs.inputFormGroup.getDOMNode().className).toContain \
          "has-error"


  describe '#handleItemSelected', ->

    beforeEach ->
      @item    = val: "data"
      @handler = H.spy "handler"
      @e       = H.spyObj "e", ["preventDefault"]
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        handleItemSelected: @handler
        updateNameOnSelect: true
        items: []
        itemType: H.mockComponent()

    it 'calls handler set by parent in the props', ->
      @dd.handleItemSelected @e, @item
      expect(@e.preventDefault).toHaveBeenCalled()
      expect(@handler).toHaveBeenCalledWith @item

    it 'does not call handler if not provided', ->
      @dd.props.handleItemSelected = undefined
      @dd.handleItemSelected @e, @item
      expect(@e.preventDefault).toHaveBeenCalled()
      expect(@handler).not.toHaveBeenCalled()


  describe '#handleInputChange', ->

    beforeEach ->
      @restore = H.rewire Dropdown, MAX_INPUT_LENGTH: 5
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: []
        itemType: H.mockComponent()
        handleItemAdd: ->
      H.spyOn @dd, "setState"

    afterEach ->
      @restore()

    it 'disables button if input is >= max allowed length', ->
      input = @dd.refs.itemName.getDOMNode()
      input.value = "12345"
      @dd.handleInputChange()
      expect(@dd.setState).toHaveBeenCalledWith buttonDisabled: true
      input.value = "123456789"
      @dd.handleInputChange()
      expect(@dd.setState).toHaveBeenCalledWith buttonDisabled: true

    it 'enables button otherwise', ->
      input = @dd.refs.itemName.getDOMNode()
      input.value = "1234"
      @dd.handleInputChange()
      expect(@dd.setState).toHaveBeenCalledWith buttonDisabled: false
      @dd.setState.calls.reset()
      input.value = ""
      @dd.handleInputChange()
      expect(@dd.setState).toHaveBeenCalledWith buttonDisabled: false


  describe '#getItem', ->

    beforeEach ->
      @factory = H.mockComponent()
      @bindRet = ->
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: []
        itemType: @factory
        handleItemDelete: ->
      H.spyOn(@dd.handleItemSelected, "bind").and.returnValue @bindRet
      @item = {id: "k1", val: "v1"}

    it 'returns the correct item component', ->
      div = @dd.getItem @item
      expect(div.key).toEqual @item.id
      expect(div.props.item).toEqual @item
      expect(div.props.handleItemDelete).toEqual @dd.props.handleItemDelete


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

    describe "when handleItemAdd handler provided", ->

      beforeEach ->
        @handler = H.spy "handler"
        @props.handleItemAdd = @handler
        @props.addItemPlaceholder = "Add custom item"
        @dd = H.render Dropdown, @props

      it 'renders input to add item', ->
        ul = H.findWithTag @dd, "ul"
        children = ul.props.children
        expect(children.length).toEqual 4
        expect(children[2].key).toEqual "add-divider"

        input = H.findWithTag ul, "input"
        expect(input.props.placeholder).toEqual @props.addItemPlaceholder

      it 'calls handleItemAdd when form submitted', ->
        form = H.findWithTag @dd, "form"
        @dd.refs.itemName.getDOMNode().value = "My schedule"
        H.sim.submit form.getDOMNode()
        expect(@handler).toHaveBeenCalled()

      it 'enables and disables button correctly based on state', ->
        @dd.setState buttonDisabled: false, =>
          expect(H.findWithTag(@dd, "button").props.disabled).toEqual false
        @dd.setState buttonDisabled: true, =>
          expect(H.findWithTag(@dd, "button").props.disabled).toEqual true

      # TODO there's no proper way to test this right now apparently
      # will have to wait for issue to be resolved
      xit 'calls handleInputChange when input changes', ->
        H.spyOn @dd, "handleInputChange"

        input = H.findWithTag @dd, "input"
        H.sim.change input.getDOMNode()
        expect(@dd.handleInputChange).toHaveBeenCalled()


