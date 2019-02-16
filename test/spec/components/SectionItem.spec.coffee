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

H           = require '../../SpecHelper'
Popover     = require '../../../app/scripts/components/Popover'
SectionItem = require '../../../app/scripts/components/SectionItem'


describe 'SectionItem', ->

  beforeEach ->
    @data =
      id: "5fb6679adb55"
      sectionId:  "45578"
      sectionNumber: 2
      courseName: "Algebra"
      courseCode: "MATE1203"
      seats:
        available: 20
      teacherNames: ["Dimitri Alejo", "Juan Tejada"]
      credits: 3
      departments: [{name: "Math Department"}]
    @restore = H.rewire SectionItem,
      SectionUtils:
        seatsColorClass: -> "success"
        teacherNames: -> "Dimitri Alejo, Juan Tejada"
        department: -> "Math Department"
        fieldFor: -> "seats.available"

  afterEach ->
    @restore()

  describe '#render', ->

    assertRenderedState = (item, data)->
      contentId = "section-info-#{data.id}"
      colorId   = "section-colors-#{data.id}"

      heading   = H.findWithClass item, "panel-heading"
      trigger   = H.findWithTag heading, "a"
      code      = trigger.props.children[0]
      name      = trigger.props.children[1]
      content   = H.findWithClass item, "panel-collapse"
      info_list = H.scryWithClass item, "list-group-item"
      settingsTrigger = H.findWithType item, Popover

      expect(heading.props.style.borderColor).toEqual data.color

      expect(trigger.props.href).toEqual "##{contentId}"
      expect(trigger.props["data-toggle"]).toEqual "collapse"
      expect(code.type).toEqual "span"
      expect(code.props.children).toEqual "#{data.courseCode} - "
      expect(name.type).toEqual "strong"
      expect(name.props.children).toEqual data.courseName

      expect(content.props.id).toEqual contentId
      expect(content.props.style.borderColor).toEqual data.color

      expect(info_list[0].props.children).toContain data.seats.available
      expect(info_list[1].props.children).toEqual data.teacherNames.join(", ")

      expect(info_list[2].props.children).toContain data.credits
      expect(info_list[2].props.children).toContain data.sectionNumber
      expect(info_list[2].props.children).toContain data.sectionId

      final = info_list[3].props.children
      expect(final.props.children).toContain data.departments[0].name

      expect(settingsTrigger).toBeDefined()


    it 'renders correctly', ->
      item = H.render SectionItem, item: @data
      assertRenderedState item, @data


  H.itBehavesLike 'item', itemClass: SectionItem
