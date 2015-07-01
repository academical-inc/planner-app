
AcademicalError = require './AcademicalError'

class NavError extends AcademicalError

  constructor: (@requestError, msg)->
    super(msg)

module.exports = NavError

