
H        = require '../../SpecHelper'
Dropdown = require '../../../app/scripts/components/Dropdown'


describe 'Dropdown', ->

  describe '#handleItemSelected', ->

    beforeEach ->
      @item = val: "data"
      @handler = H.spy "handler"
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        handleItemSelected: @handler
        updateNameOnSelect: true
        items: []

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


  describe '#renderItems', ->

    assertRenderedItem = (item, expected)->
      expect(item.key).toEqual expected.key
      if expected.icon?
        expect(H.findWithTag(item, "a").props.children[0]).toEqual expected.icon
        expect(H.findWithTag(item, "a").props.children[1]).toEqual \
          " #{expected.val}"
      else
        expect(H.findWithTag(item, "a").props.children).toEqual expected.val

    beforeEach ->
      @dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: []

    it 'renders dropdown items correctly when headers present', ->
      data = [
        {key: "k1", val: "v1"}
        {header: "h1", items: [{key: "k2", val: "v2"}, {key: "k3", val: "v3"}]}
        {key: "k4", val: "v4"}
      ]
      items = @dd.renderItems data

      expect(items.length).toEqual 6
      assertRenderedItem items[0], data[0]
      expect(items[1].props.children).toEqual "h1"
      for i in [2..3]
        assertRenderedItem items[i], data[1].items[i-2]
      expect(items[4].props.className).toEqual "divider"
      assertRenderedItem items[5], data[2]

    it 'renders dropdown items correctly when only headers present', ->
      data = [
        {header: "h1", items: [{key: "k1", val: "v1"}]}
        {header: "h2", items: [{key: "k2", val: "v2"}]}
      ]
      items = @dd.renderItems data
      expect(items.length).toEqual 5
      d = 0
      for i in [0, 3]
        expect(items[i].props.children).toEqual data[d].header
        assertRenderedItem items[i+1], data[d].items[0]
        # Don't render last divider:
        expect(items[i+2].props.className).toEqual "divider" if d == 0
        d += 1

    it 'renders dropdown items correctly when no headers present', ->
      data = [
        {key: "k1", val: "v1"}
        {key: "k2", val: "v2"}
      ]
      items = @dd.renderItems data
      expect(items.length).toEqual 2
      assertRenderedItem items[0], data[0]
      assertRenderedItem items[1], data[1]

    it 'renders icons for items correctly when icons specified', ->
      data = [
        {key: "k1", val: "v1", icon: "i"}
      ]
      items = @dd.renderItems data
      expect(items.length).toEqual 1
      assertRenderedItem items[0], data[0]



  describe '#render', ->

    it 'renders state and props correctly', ->
      root = H.mockComponent()
      dd = H.render Dropdown,
        rootTag: H.mockComponent()
        items: [{key: "k1", val: "v1"}, {key: "k2", val: "v2"}]
        title: "title"
        className: "klass"

      ddNode = dd.getDOMNode()
      expect(ddNode.tagName.toLowerCase()).toEqual root.type
      expect(ddNode.getAttribute("class")).toContain "klass"
      expect(ddNode.getAttribute("class")).toContain "dropdown"

      toggle = H.findWithClass dd, "dropdown-toggle"
      expect(toggle.props.children[0]).toEqual "title"

      ul = H.findWithTag dd, "ul"
      expect(ul.props.children.length).toEqual 2



