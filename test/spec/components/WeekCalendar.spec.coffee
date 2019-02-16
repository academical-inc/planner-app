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

Humps        = require 'humps'
H            = require '../../SpecHelper'
WeekCalendar = require '../../../app/scripts/components/WeekCalendar'

sections     = Humps.camelizeKeys require '../../fixtures/sections.json'


describe 'WeekCalendar', ->


  describe '#componentDidMount', ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire WeekCalendar,
        $: @mock$
      @cal = H.render WeekCalendar

    afterEach ->
      @restore

    it 'should initialize the fullcalendar plugin', ->
      expect(@mock$).toHaveBeenCalledWith(@cal.getDOMNode())
      expect(@mock$El.fullCalendar).toHaveBeenCalled()


  describe '#sectionEventDataTransform', ->

    beforeEach ->
      @sec = sections[0]
      @ev  = @sec.events[0].expanded[0]
      @ev.parent = @sec
      @restore = H.rewire WeekCalendar,
        "_sectionColors": =>
          colors = {}
          colors[@sec.id] = "red"
          colors
      @cal = H.render WeekCalendar

    it 'transforms section event data into a fullcalendar event', ->
      res = @cal.sectionEventDataTransform @ev
      expect(res).toEqual(
        id: @sec.id
        title: @sec.courseName
        description: @sec.courseDescription
        start: @ev.startDt
        end: @ev.endDt
        location: @ev.location
        backgroundColor: "red"
        borderColor: "red"
        editable: false
        allDay: false
        isSection: true
      )

