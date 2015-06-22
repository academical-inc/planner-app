
# TODO change jquery for another lib
$            = require 'jquery'
Url          = require './Url'
Utils        = require '../utils/Utils'
RequestError = require '../errors/RequestError'
Request      = require './Request'


class Resource

  constructor: (@_api)->
    @basePath = Url.makeUrlInterpolator @_api.get("basePath")
    if @path?
      @path = Url.makeUrlInterpolator @path
    else
      @path = ""

  @createApiCall: ({method, path, requiredParams})->
    path           ?= ""
    requiredParams ?= []

    (args..., cb)->
      if not (typeof cb == 'function')
        throw new Error("Academical: Must provide a callback")

      [urlArgs, data] = Url.extractUrlArgsAndData args

      urlParams = Url.getUrlParamsObj requiredParams, urlArgs
      fullUrl   = Url.fullUrl(
        @_api.get("protocol")
        @_api.get("host")
        @basePath
        @path
        path
        urlParams
      )

      data = Resource._formatRequestData method, data

      Request method, fullUrl, Resource._responseHandler(cb),
        data: data
        headers: @_api.get("headers")
        timeout: @_api.get("timeout")

  @_formatRequestData: (method, data)->
    formatted = if data?
      if method.toLowerCase() != "get"
        res = if data.data? then data: data.data else data: data
        $.extend res, data.params if data.params?
        res
      else
        if data.params?
          $.extend data, data.params
          delete data.params
        data
    else
      {}
    formatted.camelize = true
    Utils.underscoredKeys formatted

  @_responseHandler: (cb)->
    (error, res)->
      [e, result] = if error?
        [new RequestError(error.message), null]
      else if res.error? and res.error # res.error is not null and not false
        apiMessage = res.body.message
        [new RequestError(res.error.message, res.status, apiMessage),apiMessage]
      else
        [null, res.body.data]

      cb e, result


module.exports = Resource
