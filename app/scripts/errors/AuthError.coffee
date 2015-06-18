
AcademicalError = require './AcademicalError'
I18n            = require '../utils/I18n'

class AuthError extends AcademicalError

  constructor: (@requestError)->
    @message = I18n.t "errors.authError"
    super()

module.exports = AuthError
