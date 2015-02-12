

class ApiError extends Error

  constructor: (msg, @statusCode, @apiMsg, @name='AcademicalApiError')->
    @message = if @statusCode? and @apiMsg?
      @type = @name
      "API Error - #{msg}\nResponse Status: #{@statusCode}\n" +
      "API Message: #{@apiMsg}"
    else
      @type = "ConnectionError"
      "Connection Error - #{msg}"

    Error.captureStackTrace @, @


module.exports = ApiError
