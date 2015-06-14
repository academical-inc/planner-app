
AcademicalError = require './AcademicalError'

class AppError extends AcademicalError

  constructor: (@requestError)->

module.exports = AppError
