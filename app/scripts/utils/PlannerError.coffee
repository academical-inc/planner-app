
class PlannerError extends Error

  constructor: (@message, @statusCode) ->
    Error.captureStackTrace @, @

module.exports = PlannerError
