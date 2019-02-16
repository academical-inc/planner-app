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

Router            = require '../utils/Router'
Auth              = require '../utils/Auth'
ApiUtils          = require '../utils/ApiUtils'
ActionUtils       = require '../utils/ActionUtils'
UserFactory       = require '../factories/UserFactory'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
AuthError         = require '../errors/AuthError'
{ActionTypes}     = require '../constants/PlannerConstants'

class AuthActions

  @fetchUser: (user)->
    PlannerDispatcher.dispatchServerAction
      type: ActionTypes.FETCH_USER
      user: user

    ApiUtils.fetchUser(
      UserFactory.create(user)
      ActionUtils.handleServerResponse(
        ActionTypes.FETCH_USER_SUCCESS
        ActionTypes.FETCH_USER_FAIL
        (response)-> user: response
        (err)-> error: new AuthError err
      )
    )
    return

  @login: (connection)->
    PlannerDispatcher.dispatchServerAction
      type: ActionTypes.LOGIN_USER
      connection: connection
    Auth.login connection
    return

  @logout: ->
    PlannerDispatcher.dispatchServerAction
      type: ActionTypes.LOGOUT_USER
    Router.redirect '/'
    return

module.exports = AuthActions
