
AcademicalError = require './AcademicalError'

class AppError extends AcademicalError

  constructor: (@requestError, msg)->
    super(msg)

module.exports = AppError
