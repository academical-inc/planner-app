
DataHelpers = require './DataHelpers'

resources =
  Schools:   require './resources/Schools'
  Students:  require './resources/Students'
  Schedules: require './resources/Schedules'


class Academical

  @DEFAULT_HOST:       'academical-api-staging.herokuapp.com'
  @DEFAULT_PROTOCOL:   'https'
  @DEFAULT_BASE_PATH:  '/'
  @DEFAULT_TIMEOUT:    120000
  @DEFAULT_HEADERS: {
    "Content-Type": "application/json"
    "Accept": "application/json"
  }

  #TODO should add api key and auth when functionality available
  constructor: (resMap = resources)->
    @_api =
      auth:      null
      host:      Academical.DEFAULT_HOST
      protocol:  Academical.DEFAULT_PROTOCOL
      basePath:  Academical.DEFAULT_BASE_PATH
      timeout:   Academical.DEFAULT_TIMEOUT
      headers:   Academical.DEFAULT_HEADERS
      agent:     null
      dev:       false

    # Prepping resources
    @_prepResources resMap

    # Resource data helpers
    @data = DataHelpers

  get: (field)->
    @_api[field]

  setHost: (host, protocol) ->
    @setProtocol protocol if protocol?
    @_set "host", host

  setProtocol: (protocol)->
    @_set "protocol", protocol

  setBasePath: (basePath)->
    @_set "basePath", basePath

  setHeaders: (headers)->
    @_set "headers", headers

  setTimeout: (timeout)->
    @_set "timeout", timeout

  _set: (field, value)->
    @_api[field] = value
    return

  _prepResources: (resMap)->
    for name of resMap
      @[name.toLowerCase()] = new resMap[name](@)


module.exports = Academical
