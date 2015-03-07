
# TODO change jquery for another lib
$        = require 'jquery'
Humps    = require 'humps'
Url      = require './Url'
ApiError = require './ApiError'
request  = require './request'


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

      request method, fullUrl, Resource._responseHandler(cb),
        data: data
        headers: @_api.get("headers")
        timeout: @_api.get("timeout")

  @_formatRequestData: (method, data={})->
    formatted = if method.toLowerCase() != "get"
      if data.data?
        data: data.data
      else
        data: data
    else
      data
    formatted.camelize = true
    formatted = $.extend {}, formatted, data.params if data.params?
    Humps.decamelizeKeys formatted

  @_responseHandler: (cb)->
    (error, res)->
      [e, result] = if error?
        [new ApiError(error.message), null]
      else if res.error? and res.error # res.error is not null and not false
        apiMessage = res.body.message
        [new ApiError(res.error.message, res.status, apiMessage), apiMessage]
      else
        [null, res.body.data]

      cb e, result


module.exports = Resource
