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

ApiUtils          = require '../utils/ApiUtils'
ExportUtils       = require '../utils/ExportUtils'
ActionUtils       = require '../utils/ActionUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class ExportActions

  @exportToImage: (element)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.EXPORT_IMAGE

    ExportUtils.exportToImage element, (canvas)->
      PlannerDispatcher.dispatchViewAction
        type: ActionTypes.EXPORT_IMAGE_SUCCESS
        canvas: canvas
    return

  @exportToICS: (scheduleId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.EXPORT_ICS

    ApiUtils.getSchedule scheduleId, ActionUtils.handleServerResponse(
      ActionTypes.EXPORT_ICS_SUCCESS
      ActionTypes.EXPORT_ICS_FAIL
      (response)-> icsData: response
    ), format: 'ics'
    return


module.exports = ExportActions
