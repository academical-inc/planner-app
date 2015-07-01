
$       = require 'jquery'
Lscache = require 'lscache'
Store   = require './Store'
Auth    = require '../utils/Auth'

{ActionTypes, AuthConstants} = require '../constants/PlannerConstants'


# Private
_user = null
_authToken = null

clear = ->
  _authToken = null
  _user      = null

loggedIn = ->
  _authToken? and _user?

logout = ->
  clear()
  Lscache.remove AuthConstants.TOKEN_STORAGE
  Lscache.remove AuthConstants.USER_STORAGE

updateUser = (user)->
  _user = $.extend true, {}, _user, user
  Lscache.set AuthConstants.USER_STORAGE, _user


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

      [_user, _authToken] = Auth.parseHash()
      if loggedIn()
        Lscache.set tokenStorage, _authToken, expiration
        Lscache.set userStorage, _user, expiration
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
