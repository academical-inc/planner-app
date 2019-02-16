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

PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{saveSchedule}    = require './ScheduleActions'


class SectionActions

  @addSection: (section, color)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.ADD_SECTION
      section: section
      color: color
    saveSchedule()

  @changeSectionColor: (sectionId, color)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CHANGE_SECTION_COLOR
      sectionId: sectionId
      color: color
    saveSchedule()

  @removeSection: (sectionId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.REMOVE_SECTION
      sectionId: sectionId
    saveSchedule()

  @addPreview: (section, previewType)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.ADD_SECTION_PREVIEW
      previewType: previewType
      section: section

  @removePreview: (previewType)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.REMOVE_SECTION_PREVIEW
      previewType: previewType


module.exports = SectionActions
