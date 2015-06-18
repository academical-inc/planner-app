
AcademicalError = require './AcademicalError'

class NavError extends AcademicalError

  constructor: (@requestError)->
    super()

module.exports = NavError

