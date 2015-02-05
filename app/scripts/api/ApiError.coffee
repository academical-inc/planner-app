

class ApiError extends Error

  constructor: (msg, @statusCode, @apiMsg, @name='ApiError')->
    @message = if @statusCode? and @apiMsg?
      "Academical API Error: #{msg}\nResponse Status: #{@status}\n
        API Message: #{@apiMsg}"
    else
      "Academical Connection Error: #{msg}"

    Error.captureStackTrace @, @

module.exports = ApiError
