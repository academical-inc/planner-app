
Path = require 'path'


class Url

  @fullUrl: (protocol, paths..., urlParams)->
    try
      "#{protocol}://" + Path.join.apply(
        Path,
        paths.map (path)->
          if typeof path == 'function'
            path urlParams
          else
            Url.makeUrlInterpolator(path) urlParams
      )
    catch
      throw new Error("Academical: Required paths that are strings or functions
        that return strings, but got #{paths}")

  ###
    Outputs a map or object of url params based on required keys and their
    values

    @example
      Url.getUrlParamsObj [1,3], ["v1", "v2"]
      => {v1: 1, v2: 3}

    @param [Array] values Array of actual values for the map
    @param [Array<String>] requiredKeys Array of required keys for the map
    @throw Error if array of actual values does not match length of required
      keys, or if any value is null or undefined
    @return [Object] Object mapping required keys to their values
  ###
  @getUrlParamsObj: (requiredKeys, values)->
    urlParams = {}
    requiredKeys.forEach (key)->
      urlParams[key] = if values[0]?
        values.shift()
      else
        throw new Error "Academical: Required URL param #{key},
          but got #{values[0]}"

    if values.length > 0
      throw new Error "Academical: Unknown args (#{values})."
    urlParams

  ###
   https://gist.github.com/padolsey/6008842
   Outputs a new function with interpolated object property values.
   Use like so:
     var fn = makeURLInterpolator('some/url/{param1}/{param2}');
     fn({ param1: 123, param2: 456 }); // => 'some/url/123/456'
  ###
  @makeUrlInterpolator: do ->
    rc =
      '\n': '\\n'
      '"': '\"'
      '\u2028': '\\u2028'
      '\u2029': '\\u2029'
    (str) ->
      new Function('o', 'return "' + str.replace(/["\n\r\u2028\u2029]/g, ($0) ->
        rc[$0]
      ).replace(/\{([\s\S]+?)\}/g, '" + encodeURIComponent(o["$1"]) + "') + '";')


module.exports = Url
