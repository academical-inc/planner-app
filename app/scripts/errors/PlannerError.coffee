
AcademicalError = require './AcademicalError'

class PlannerError extends AcademicalError

  constructor: (@message, @statusCode) ->

module.exports = PlannerError
