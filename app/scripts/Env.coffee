

class Env

  @SECTIONS_URL:  process.env.SECTIONS_URL
  @API_HOST:      process.env.API_HOST
  @API_PROTOCOL:  process.env.API_PROTOCOL

  @isDevelopment: ->
    process.env.APP_ENV == "development"

  @isProduction: ->
    process.env.APP_ENV == "production"

  @isTest: ->
    proccess.env.APP_ENV == "test"


module.exports = Env
