
Url     = require './Url'
request = require './request'


class Resource

  constructor: (@_api)->
    @basePath = Url.makeUrlInterpolator @_api.get("basePath")
    if @path?
      @path = Url.makeUrlInterpolator @path
    else
      @path = ""

  @createApiCall: ({method, path, requiredParams})->
    path ?= ""
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

      data = Resource._formatRequestData method, data if data?

      request method, fullUrl, Resource._responseParser(cb),
        data: data
        headers: @_api.get("headers")
        timeout: @_api.get("timeout")

  @_responseParser: (cb)->
    (res)->
      cb res.data

  @_formatRequestData: (method, data)->
    if method.toLowerCase() != "get"
      data: data
    else
      data


module.exports = Resource
