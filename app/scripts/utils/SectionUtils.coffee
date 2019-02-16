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

SchoolStore   = require '../stores/SchoolStore'
_             = require '../utils/Utils'
I18n          = require '../utils/I18n'
{UiConstants} = require '../constants/PlannerConstants'


class SectionUtils

  @fieldFor: (key)->
    @fields ?= SchoolStore.school().appUi.infoFields
    @fields[key]

  @department: (section)->
    # TODO Need to make this more flexible. Only working for our 2 current
    # schools
    depInfo = @fieldFor("department")
    arr     = _.getNested section, depInfo.list
    if arr.length > 0
      arr[0][depInfo.field]
    else
      I18n.t "section.noDepartment"

  @teacherNames: (section)->
    if section.teacherNames.length > 0
      section.teacherNames.join ", "
    else
      I18n.t "section.noTeacher"

  @seatsColorClass: (section, school=SchoolStore.school().nickname)->
    # TODO Make this not hardcoded
    seatsMap = UiConstants.sectionSeatsMap
    if section.seats.available >= seatsMap.UPPER.bound
      if school is "cesa"
        seatsMap.ZERO.className
      else
        seatsMap.UPPER.className
    else if section.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      if school is "cesa"
        seatsMap.UPPER.className
      else
        seatsMap.ZERO.className


module.exports = SectionUtils
