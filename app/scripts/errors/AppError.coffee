
AcademicalError = require './AcademicalError'

class AppError extends AcademicalError

  constructor: (@requestError)->
    super()

module.exports = AppError
