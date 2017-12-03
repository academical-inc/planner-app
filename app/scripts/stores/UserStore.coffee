
$         = require 'jquery'
Lscache   = require 'lscache'
Store     = require './Store'
Auth      = require '../utils/Auth'
AuthError = require '../errors/AuthError'

{ActionTypes, AuthConstants, Pages} = require '../constants/PlannerConstants'


# Private
TOKEN_RENEWAL_INTERVAL = 5 * 60 * 1000 # 5 minutes

_user = null
_authToken = null
_interval = null

clear = ->
  clearInterval(_interval)
  _authToken = null
  _user      = null
  _interval  = null

loggedIn = ->
  _authToken? and _user?

logout = ->
  clear()
  Lscache.remove AuthConstants.TOKEN_STORAGE
  Lscache.remove AuthConstants.USER_STORAGE

updateUser = (user)->
  _user = $.extend true, {}, _user, user
  Lscache.set AuthConstants.USER_STORAGE, _user

onTokenRenewed = (errorDesc, token, error)->
  if !loggedIn()
    return
  if !!errorDesc or !!error
    logout()
    err = new AuthError('Could not renew token')
    Router = require '../utils/Router'
    Router.goTo Pages.LANDING, error: err.message
  else
    _authToken = token

renewAuthToken = ->
  if !loggedIn()
    return
  Auth.renewAuthToken(onTokenRenewed)

# TODO Test
class UserStore extends Store

  user: ->
    _user

  authToken: ->
    _authToken

  isLoggedIn: ->
    if loggedIn()
      true
    else
      tokenStorage = AuthConstants.TOKEN_STORAGE
      userStorage  = AuthConstants.USER_STORAGE
      expiration   = AuthConstants.TOKEN_EXPIRTATION
      _authToken = Lscache.get tokenStorage
      _user      = Lscache.get userStorage
      if loggedIn()
        @emitChange()
        return true

      [_user, _authToken] = Auth.extractUserAndTokenFromURL()
      if loggedIn()
        Lscache.set tokenStorage, _authToken, expiration
        Lscache.set userStorage, _user, expiration
        clearInterval(_interval)
        _interval = setInterval(renewAuthToken, TOKEN_RENEWAL_INTERVAL)
        @emitChange()
        true
      else
        clear()
        false

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.FETCH_USER_SUCCESS
        updateUser action.user
        @emitChange()
      when ActionTypes.FETCH_USER_FAIL
        logout()
      when ActionTypes.LOGOUT_USER
        logout()
        @emitChange()


module.exports = new UserStore
