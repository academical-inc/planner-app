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

H               = require '../../SpecHelper'
ScheduleInfoBar = require '../../../app/scripts/components/ScheduleInfoBar'
PanelItemList   = require '../../../app/scripts/components/PanelItemList'


describe 'ScheduleInfoBar', ->

  describe '#render', ->

    beforeEach ->
      @sectionItem   = ->
      @eventItem     = ->
      @restore = H.rewire ScheduleInfoBar,
        SectionItem: @sectionItem
        EventItem: @eventItem

      @data =
        totalCredits: 6
        totalSections: 2
        sections: [ {id: "s1"}, {id: "s2"} ]
        events: [ {id: "p1", color: "blue"}, {id: "p2", color: "purp"} ]
        sectionColors: {s1: "red", s2: "green"}


    afterEach ->
      @restore

    assertRenderedState = (lists, data, sectionItem, eventItem)->
      expect(lists.length).toEqual 2

      sections = lists[0]
      expect(sections.props.itemType).toEqual sectionItem
      expect(sections.props.subheader).toContain data.totalSections
      expect(sections.props.subheader).toContain data.totalCredits
      expect(sections.props.items).toEqual data.sections
      expect(sections.props.colors).toEqual data.sectionColors

      events = lists[1]
      expect(events.props.itemType).toEqual eventItem
      expect(events.props.items).toEqual data.events

    it 'renders correctly based on initial state', ->
      bar   = H.render ScheduleInfoBar, initialState: @data
      lists = H.scryWithType bar, PanelItemList
      assertRenderedState lists, @data, @sectionItem, @eventItem

    it 'updates correctly when state is updated', ->
      bar   = H.render ScheduleInfoBar
      bar.setState @data, =>
        lists = H.scryWithType bar, PanelItemList
        assertRenderedState lists, @data, @sectionItem, @eventItem

