
AcademicalError = require './AcademicalError'

class NavError extends AcademicalError

  constructor: (@requestError)->

module.exports = NavError

