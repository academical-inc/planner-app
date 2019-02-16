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

H         = require '../../SpecHelper'
Popover   = require '../../../app/scripts/components/Popover'
EventItem = require '../../../app/scripts/components/EventItem'


describe 'EventItem', ->

  beforeEach ->
    @data =
      id: '1'
      name: "event"
    @color = "red"
    @handler = H.spy "handler"

  describe '#render', ->

    it 'renders correctly', ->
      event   = H.render EventItem, item: @data, color: @color
      heading = H.findWithClass event, "panel-heading"
      name    = H.scryWithTag(event, "a")[0]
      settingsTrigger = H.findWithType event, Popover

      colorsId = "event-colors-#{@data.id}"

      expect(heading.props.id).toEqual "event-heading-#{@data.id}"
      expect(heading.props.style.borderColor).toEqual @color
      expect(name.props.children).toEqual @data.name
      expect(settingsTrigger).toBeDefined()


  H.itBehavesLike "item", itemClass: EventItem

