
_               = require '../utils/Utils'
Auth0           = require 'auth0-js'
Env             = require '../Env'
SchoolStore     = require '../stores/SchoolStore'
UserFactory     = require '../factories/UserFactory'
AuthError       = require '../errors/AuthError'
{AuthConstants} = require '../constants/PlannerConstants'

_auth0 = new Auth0
  domain: Env.AUTH0_DOMAIN
  clientID: Env.AUTH0_CLIENT_ID
  callbackURL: _.origin()
  callbackOnLocationHash: true

# TODO Test
class Auth

  @login: (
    connection,
    scope=AuthConstants.AUTH0_SCOPE,
    state=window.location.pathname,
    school=SchoolStore.school().nickname
  )->
    _auth0.login
      connection: connection
      scope: scope
      state: state
      school: school

  @parseHash: (hash=window.location.hash)->
    result = _auth0.parseHash hash
    if result?
      if result.error?
        throw new AuthError result.error
      if result.id_token? and result.profile?
        result.profile['auth0UserId'] = result.profile.sub
        user      = UserFactory.create result.profile
        authToken = result.id_token
        return [user, authToken]
    [null, null]


module.exports = Auth
