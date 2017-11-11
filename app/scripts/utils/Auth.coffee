
_               = require '../utils/Utils'
Auth0           = require 'auth0-js'
Adal            = require 'adal-angular'
QueryString     = require 'query-string'
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

  @base64Decode: (encoded) ->
    encoded = encoded
      .replace(/\-/g, '+')
      .replace(/\_/g, '/')

    return window.atob(encoded)

  @decodeJWT: (jwt)->
    try
      encoded = jwt and jwt.split('.')[1]
      return JSON.parse(Auth.base64decode(encoded))
    catch error
      throw new AuthError error.message

  @extractUserAndTokenFromURL: (location=window.location)->
    hash = location.hash
    isAcademicalAuth = /academical_auth/.test(hash)
    if isAcademicalAuth
      parsedQS = QueryString.parse(hash)
      if !parsedQS
        return [null, null]

      authToken = parsedQS.id_token
      parsedToken  = Auth.decodeJWT(authToken)
      user = UserFactory.create({
        email: parsedToken.unique_name,
        name: parsedToken.name,
        auth0UserId: "waad|#{parsedToken.unique_name}",
      })
      return [user, authToken]
    else
      result = _auth0.parseHash hash
      if result?
        if result.error?
          throw new AuthError result.error
        if result.id_token? and result.profile?
          result.profile['auth0UserId'] = result.profile.sub
          user      = UserFactory.create result.profile
          authToken = result.id_token
          return [user, authToken]
      return [null, null]


module.exports = Auth
