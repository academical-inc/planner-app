

class Academical

  @DEFAULT_HOST:       'academical-api-staging.herokuapp.co'
  @DEFAULT_PORT:       '80'
  @DEFAULT_PROTOCOL:   'https'
  @DEFAULT_BASE_PATH:  '/'
  @DEFAULT_TIMEOUT:    120000
  @DEAFULT_HEADERS:
    "Content-Type": "application/json"
    "Accept": "application/json"


  #TODO should add api key and auth when functionality available
  constructor: ()->
    @_api =
      auth:      null
      host:      Academical.DEFAULT_HOST
      port:      Academical.DEFAULT_PORT
      protocol:  Academical.DEFAULT_PROTOCOL
      basePath:  Academical.DEFAULT_BASE_PATH
      timeout:   Academical.DEFAULT_TIMEOUT
      headers:   Academical.DEFAULT_HEADERS
      agent:     null
      dev:       false

    # Prepping resources
    @schools   = require './resources/Schools'
    @students  = require './resources/Students'
    @schedules = require './resources/Schedules'


  getApiField: (field)->
    @_api[field]

  setHost: (host, port, protocol) ->
    @_setApiField "host", host
    @setPort port if port
    return

  setPort: (port)->
    @_setApiField "port", port

  setProtocol: (protocol)->
    @_setApiField "protocol", protocol

  setHeaders: (headers)->
    @_setApiField "headers", headers

  setTiemout: (timeout)->
    @_setApiField "tiemout", tiemout

  _setApiField: (field, value)->
    @_api[field] = value


module.exports = Academical
