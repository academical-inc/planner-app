
Path = require 'path'


class Url

  @fullUrl: (paths..., urlParams)->
    Path.join.apply(
      paths.map (path)->
        if typeof path == 'function'
          path urlParams
        else
          Url.makeUrlInterpolator(path) urlParams
    )

  @getUrlParamsObj: (actual, required)->
    urlParams = {}
    required.forEach (key)->
      urlParams[key] = if actual[0]?
        actual.shift()
      else
        throw new Error "Academical: Required URL param #{key},
          but got #{actual[0]}"

    if actual.length > 0
      throw new Error "Academical: Unknown args (#{actual})."

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
