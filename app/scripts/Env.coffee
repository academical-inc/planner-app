
_school = process.env.SCHOOL
_appEnv = process.env.APP_ENV
_env =
  production:
    SECTIONS_URL:  process.env.production.SECTIONS_URL
    API_HOST:      process.env.production.API_HOST
    API_PROTOCOL:  process.env.production.API_PROTOCOL
  development:
    SECTIONS_URL:  process.env.development.SECTIONS_URL
    API_HOST:      process.env.development.API_HOST
    API_PROTOCOL:  process.env.development.API_PROTOCOL
  test:
    SECTIONS_URL:  process.env.test.SECTIONS_URL
    API_HOST:      process.env.test.API_HOST
    API_PROTOCOL:  process.env.test.API_PROTOCOL


class Env

  @SECTIONS_URL:  _env[_appEnv].SECTIONS_URL
  @API_HOST:      _env[_appEnv].API_HOST
  @API_PROTOCOL:  _env[_appEnv].API_PROTOCOL
  @SCHOOL:        _school

  @isDevelopment: ->
    _appEnv == "development"

  @isProduction: ->
    _appEnv == "production"

  @isTest: ->
    _appEnv == "test"


module.exports = Env
