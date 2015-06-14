
$               = require 'jquery'
Store           = require './Store'
Auth           = require '../utils/Auth'
{ActionTypes}   = require '../constants/PlannerConstants'
{AuthConstants} = require '../constants/PlannerConstants'


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
  localStorage.removeItem AuthConstants.TOKEN_STORAGE
  localStorage.removeItem AuthConstants.USER_STORAGE

updateUser = (user)->
  _user = $.extend true, {}, _user, user
  localStorage.setItem AuthConstants.USER_STORAGE, JSON.stringify(_user)


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
      _authToken = localStorage.getItem tokenStorage
      _user      = JSON.parse localStorage.getItem(userStorage)
      if loggedIn()
        @emitChange()
        return true

      [_user, _authToken] = Auth.parseHash()
      if loggedIn()
        localStorage.setItem tokenStorage, _authToken
        localStorage.setItem userStorage, JSON.stringify(_user)
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


module.exports = new UserStore
