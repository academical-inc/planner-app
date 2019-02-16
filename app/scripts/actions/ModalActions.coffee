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


class ModalActions

  @openEventForm: (startDt, endDt)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.OPEN_EVENT_FORM
      startDt: startDt
      endDt: endDt

  @openSummaryDialog: ->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.OPEN_SUMMARY_DIALOG


module.exports = ModalActions
