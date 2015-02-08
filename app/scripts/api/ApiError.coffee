

class ApiError extends Error

  constructor: (msg, @statusCode, @apiMsg, @name='AcademicalApiError')->
    @message = if @statusCode? and @apiMsg?
      "API Error - #{msg}\nResponse Status: #{@statusCode}\n" +
      "API Message: #{@apiMsg}"
    else
      "Connection Error - #{msg}"

    Error.captureStackTrace @, @


module.exports = ApiError
