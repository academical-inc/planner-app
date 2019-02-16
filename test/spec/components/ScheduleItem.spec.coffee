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

    it 'renders spinner when item (schedule) is for delete', ->
      @props.item.del = true
      item = H.render ScheduleItem, @props
      icon = H.findWithClass item, "fa-spinner"

      expect(H.scryWithClass(item, "delete-icon")).toEqual []
      expect(item.props.onClick).toEqual @props.onClick

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


