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

AppError          = require '../errors/AppError'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'


# TODO Test
class ActionUtils

  @handleServerResponse: (
    successAction
    errorAction
    successPayload=->{}
    errorPayload=->{}
  )->
    (err, response)->
      if err?
        payload       = error: new AppError err
        payload       = $.extend true, {}, payload, errorPayload(err, response)
        payload.type  = errorAction
        PlannerDispatcher.dispatchServerAction payload
      else
        payload      = successPayload response
        payload.type = successAction
        PlannerDispatcher.dispatchServerAction payload
      return


module.exports = ActionUtils
