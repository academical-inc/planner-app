
module.exports =
  urls:
    SECTIONS_URI: process.env.SECTIONS_URI
    API_URI: process.env.API_URI
  env:
    isDevelopment: ->
      process.env.APP_ENV == "development"
    isProduction: ->
      process.env.APP_ENV == "production"
    isTest: ->
      proccess.env.APP_ENV == "test"
