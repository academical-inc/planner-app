
_               = require '../utils/Utils'
Auth0           = require 'auth0-js'
Adal            = require 'adal-angular'
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

_adalConfig = {
  tenant: 'uniandes.edu.co',
  clientId: 'de60bc32-cb18-48ee-8ec5-edf9ed56850b'
  disableRenewal: true
  # instance: 'https://uniandes.onmicrosoft.com/academical',
  # TODO add a state parameter
  # extraQueryParameter: 'nux=1',
  # endpoints: {
  #   'https://graph.microsoft.com': 'https://graph.microsoft.com'
  # }
  # cacheLocation: 'localStorage'
}

_adal = new Adal(_adalConfig)

# TODO Test
class Auth

  @login: (
    connection,
    scope=AuthConstants.AUTH0_SCOPE,
    state=window.location.pathname,
    school=SchoolStore.school().nickname
  )->
    if connection is 'uniandes.edu.co'
      _adal.login()
    else
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
