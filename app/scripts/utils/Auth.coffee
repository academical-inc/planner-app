
Auth0           = require 'auth0-js'
Env             = require '../Env'
UserFactory     = require '../factories/UserFactory'
AuthError       = require '../errors/AuthError'
{AuthConstants} = require '../constants/PlannerConstants'

_auth0 = new Auth0
  domain: Env.AUTH0_DOMAIN
  clientID: Env.AUTH0_CLIENT_ID
  callbackURL: window.location.href
  callbackOnLocationHash: true

# TODO Test
class Auth

  @login: (connection, scope=AuthConstants.AUTH0_SCOPE)->
    _auth0.login
      connection: connection
      scope: scope

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
