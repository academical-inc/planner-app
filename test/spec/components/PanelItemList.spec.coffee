#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
        items: [{id: "item1", color: "b"}, {id: "item2", color: "r"}]
        colors: {item1: "g", item2: "l"}
        handleItemDelete: ->

    it 'renders the list of items correctly when item has color', ->
      list     = H.render PanelItemList, @defProps
      expected = @defProps.items

      items = H.findWithClass(list, "panel-group").props.children
      expect(items.length).toEqual expected.length
      items.forEach (item, i)=>
        expect(item).toEqual "data"
        expect(@itemType.calls.argsFor(i)).toEqual [{
          key: expected[i].id
          item: expected[i]
          color: expected[i].color
          handleItemDelete: @defProps.handleItemDelete
        }]

    it 'renders the list of items correctly when item has no color', ->
      @defProps.items = [{id: "item1"}, {id: "item2"}]
      list     = H.render PanelItemList, @defProps
      expected = @defProps.items

      items = H.findWithClass(list, "panel-group").props.children
      expect(items.length).toEqual expected.length
      items.forEach (item, i)=>
        expect(item).toEqual "data"
        expect(@itemType.calls.argsFor(i)).toEqual [{
          key: expected[i].id
          item: expected[i]
          color: @defProps.colors[expected[i].id]
          handleItemDelete: @defProps.handleItemDelete
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


