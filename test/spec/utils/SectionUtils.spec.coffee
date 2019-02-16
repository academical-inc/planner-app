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
SectionUtils = require '../../../app/scripts/utils/SectionUtils'


describe 'SectionUtils', ->

  describe '#seatsColorClass', ->

    seats = (seats)->
      seats: available: seats

    beforeEach ->
      @restore = H.rewire SectionUtils,
        UiConstants:
          sectionSeatsMap:
            UPPER: bound: 50, className: "upper"
            LOWER: bound: 15, className: "lower"
            ZERO:  className: "zero"

    afterEach ->
      @restore()

    it 'returns correct css class when seats available is >= upper bound ', ->
      sec = seats 50
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "upper"

      sec = seats 60
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "upper"

    it 'returns correct css class when seats available is < upper bound and
        >= lower bound', ->
      sec = seats 15
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "lower"

      sec = seats 20
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "lower"

    it 'returns correct css class when seats available is < lower bound ', ->
      sec = seats 14
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "zero"

      sec = seats 0
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "zero"

      sec = seats -3
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "zero"

