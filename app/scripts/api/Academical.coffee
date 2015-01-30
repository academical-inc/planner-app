

class Academical

  @DEFAULT_HOST:       'academical-api-staging.herokuapp.co'
  @DEFAULT_PORT:       '80'
  @DEFAULT_BASE_PATH:  '/'
  @DEFAULT_TIMEOUT:    120000


  #TODO should add api key and auth when functionality available
  constructor: ()->
    @_api =
      auth: null
      host: Academical.DEFAULT_HOST
      port: Academical.DEFAULT_PORT
      basePath: Academical.DEFAULT_BASE_PATH
      agent: null
      dev: false

    # Prepping resources
    @schools   = require './resources/Schools'
    @students  = require './resources/Students'
    @schedules = require './resources/Schedules'


  getApiField: (field)->
    @_api[field]

  setHost: (host, port) ->
    @_setApiField "host", host
    @setPort port if port
    return

  setPort: (port)->
    @_setApiField "port", port

  _setApiField: (field, value)->
    @_api[field] = value


module.exports = Academical
