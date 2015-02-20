
Store = require './Store'
I18n  = require '../utils/I18n'


# Private
_err = null

class ErrorStore extends Store

  getError: ->
    _err

  dispatchCallback: (payload)=>
    error = payload.action.error

    if error?

      switch error.type
        when "ConnectionError"
          _err = I18n.t "errors.connError"
        when "AcademicalApiError"
          code = parseInt error.statusCode, 10
          if code >= 500
            _err = I18n.t "errors.apiError"
          else if code >= 400 and code < 500
            _err = I18n.t "errors.clientError", errMsg: error.message
        else
          # TODO Unknown error

      # TODO Log errors to server or tool
      @emitChange()


module.exports = new ErrorStore
