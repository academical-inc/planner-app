
AcademicalError = require './AcademicalError'

class RequestError extends AcademicalError

  constructor: (msg, @statusCode, @apiMsg, @name='AcademicalApiError')->
    @message = if @statusCode? and @apiMsg?
      @type = @name
      "API Error - #{msg}\nResponse Status: #{@statusCode}\n" +
      "API Message: #{@apiMsg}"
    else
      @type = "ConnectionError"
      "Connection Error - #{msg}"

module.exports = RequestError
