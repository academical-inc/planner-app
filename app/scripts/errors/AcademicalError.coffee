
class AcademicalError extends Error

  constructor: (@message) ->
    if Error.captureStackTrace?
      Error.captureStackTrace @, @
    else
      @stack = (new Error @message).stack

module.exports = AcademicalError
