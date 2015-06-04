
Store = require './Store'
I18n  = require '../utils/I18n'

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
          # TODO Handle Not Authorized
          else if code >= 400 and code < 500
            _msg = I18n.t "errors.clientError", errMsg: error.message
        else
          # TODO Unknown error

      # TODO Log errors to server or tool
      @emitChange()


module.exports = ErrorStore
