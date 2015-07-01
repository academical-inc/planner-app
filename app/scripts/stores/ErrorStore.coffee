
Store   = require './Store'
Bugnsag = require '../utils/Bugsnag'
I18n    = require '../utils/I18n'

# Private
_code = null
_msg  = null


# TODO Test
class ErrorStore extends Store

  constructor: (@_errorType)->
    super()

  code: ->
    _code

  msg: ->
    _msg

  dispatchCallback: (payload)=>
    error = payload.action.error

    if error and error instanceof @_errorType
      if error.requestError?
        error = error.requestError

        _code = error.statusCode
        switch error.type
          when "ConnectionError"
            _msg = I18n.t "errors.connError"
          when "AcademicalApiError"
            code = parseInt _code, 10
            if code >= 500
              _msg = I18n.t "errors.apiError"
            else if code == 404
              _msg = I18n.t "errors.notFound"
            else if code == 401
              _msg = I18n.t "errors.notLoggedIn"
            else if code == 403
              _msg = I18n.t "errors.notAuthorized"
            else if code >= 400 and code < 500
              _msg = I18n.t "errors.clientError", errMsg: error.message

            if code >= 500
              Bugsnag.notify error, error.type, {}, "error"
            else
              Bugsnag.notify error, error.type
          else
            Bugsnag.notify error
      else
        _msg = error.message
        Bugsnag.notify error, "CustomError", {}, "info"

      @emitChange()


module.exports = ErrorStore
