
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
