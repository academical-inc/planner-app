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

$     = require 'jquery'
H     = require '../SpecHelper'
React = require 'react'

ItemMixinExamples =

  item: ({itemClass}={})->
    beforeEach ->
      @handler = @handler or H.spy "deleteHandler"

    describe '#renderDeleteIcon', ->

      it 'renders correctly if item is being deleted', ->
        @data.del = true
        item = H.render itemClass,
          item: @data
        deleteIcon = item.renderDeleteIcon()
        expect(deleteIcon.props.className).toContain "spinner"

      it 'renders correctly if item is not being deleted', ->
        item = H.render itemClass,
          item: @data
        deleteIcon = item.renderDeleteIcon()
        expect(deleteIcon.props.className).toContain "delete-icon"

      it 'calls the on delete item callback correctly', ->
        item = H.render itemClass,
          item: @data
          handleItemDelete: @handler
        div = H.render 'div', null, item.renderDeleteIcon()

        deleteIcon = H.findWithClass div, 'delete-icon'
        H.sim.click deleteIcon.getDOMNode()
        expect(@handler).toHaveBeenCalledWith @data

    describe '#renderSettings', ->

      it 'renders settings trigger correctly', ->
        item = H.render itemClass, item: @data
        settingsTrigger = item.renderSettings()
        itemSettings = settingsTrigger.props.content
        deleteIcon = itemSettings.props.deleteIcon
        expect(itemSettings.props.handleColorSelect).toEqual \
          item.handleColorSelect
        expect(deleteIcon.props.onClick).toEqual item.handleItemDelete


jasmine.sharedExamples = if jasmine.sharedExamples?
  $.extend {}, true, jasmine.sharedExamples, ItemMixinExamples
else
  ItemMixinExamples

