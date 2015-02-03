
Url     = require './Url'
request = require './request'


class Resource

  constructor: (@_api)->
    @basePath = Url.makeUrlInterpolator @_api.getApiField("basePath")
    @path     = Url.makeUrlInterpolator @path

  createApiCall: ({method, path, requiredParams})->
    requiredParams ?= []

    (args..., cb)->
      if not (typeof cb == 'function')
        throw new Error("Academical: Must provide a callback")

      [urlArgs..., last] = args
      data = last if last.toString() == '[object Object]'

      urlParams = Url.getUrlParamsObj urlArgs, requiredParams
      fullUrl   = Url.fullUrl @basePath, @path, path, urlParams

      request method, fullUrl, Resource._responseParser(cb),
        data: Resource._formatRequestData(data)
        headers: @_api.getApiField("headers")
        timeout: @_api.getApiField("timeout")

  @_responseParser: (cb)->
    (res)->
      cb res.data

  @_formatRequestData: (data)->
    data: data


module.exports = Resource
