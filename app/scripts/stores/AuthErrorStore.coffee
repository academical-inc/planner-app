
ErrorStore = require './ErrorStore'
I18n       = require '../utils/I18n'
AuthError  = require '../errors/AuthError'

class AuthErrorStore extends ErrorStore

  msg: ->
    if super()? then super() else I18n.t "authError"

module.exports = new AuthErrorStore AuthError
