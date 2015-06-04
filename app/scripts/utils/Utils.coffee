

class Utils

  @_qs: null

  @find: (arr, test)->
    for val in arr
      return val if test val
    return null

  @findWithIdx: (arr, test)->
    for val, idx in arr
      return [val, idx] if test val
    return [null, null]

  @removeAt: (arr, idx)->
    return null if not idx? or idx >= arr.length
    arr.splice(idx, 1)[0]

  @findAndRemove: (arr, test)->
    [el, idx] = @findWithIdx arr, test
    @removeAt arr, idx
    el

  @getNested: (obj, key)->
    val = obj
    for part in key.split(".")
      return null if not val.hasOwnProperty part
      val = val[part]
    val

  # TODO Test
  @hasNested: (obj, key)->
    val = obj
    for part in key.split(".")
      return false if not val.hasOwnProperty part
      val = val[part]
    true

  @setNested: (obj, key, val)->
    parts = key.split(".")
    last  = parts[parts.length-1]
    parts[...-1].forEach (part)->
      obj[part] = {} if not obj[part]?
      obj = obj[part]
    obj[last] = val

  @objInclude: (obj, include)->
    keyList  = if Array.isArray(include) then include else Object.keys(include)
    filtered = {}

    for key in keyList
      defVal = include[key]
      if @hasNested obj, key
        @setNested filtered, key, @getNested(obj, key)
      else if defVal?
        defVal = if typeof defVal == 'function'
          defVal obj
        else
          defVal
        @setNested filtered, key, defVal
    filtered

  # https://developer.mozilla.org/en/docs/Web/JavaScript/Guide/
  # Regular_Expressions#Using_Special_Characters
  @escapeRegexCharacters: (str)->
    str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')

  @findAllRegexMatches: (re, str)->
    indices = []
    while result = re.exec(str)
      indices.push result.index
    indices

  # TODO Test
  # https://github.com/domchristie/humps/blob/master/humps.js#L49
  @camelize: (str)->
    str = str.replace /[\-_\s]+(.)?/g, (match, chr)->
      if chr then chr.toUpperCase() else ''
    # Ensure 1st char is always lowercase
    str.replace /^([A-Z])/, (match, chr)->
      if chr then chr.toLowerCase() else ''

  # http://davidwalsh.name/javascript-debounce-function
  @debounce: (func, wait, immediate) ->
    timeout = undefined
    ->
      context = this
      args = arguments

      later = ->
        timeout = null
        if !immediate
          func.apply context, args
        return

      callNow = immediate and !timeout
      clearTimeout timeout
      timeout = setTimeout(later, wait)
      if callNow
        func.apply context, args
      return

  # TODO Test
  # https://github.com/epeli/underscore.string
  @underscored: (str)->
    str.trim().replace(/([a-z\d])([A-Z]+)/g, '$1_$2').\
      replace(/[-\s]+/g, '_').toLowerCase()

  # TODO Test
  @underscoredKeys: (obj)->
    if Array.isArray obj
      obj.map (el)=> @underscoredKeys el
    else if typeof obj == 'object'
      undObj = {}
      for key of obj
        undObj[@underscored(key)] = @underscoredKeys obj[key]
      undObj
    else
      obj

  @qs: (param, queryStr=window.location.search)->
    if not @_qs?
      @_qs = {}
      params = queryStr.substr(1).split('&')
      for val in params
        p = val.split '=', 2
        if p.length == 1
          @_qs[p[0]] = ''
        else
          @_qs[p[0]] = decodeURIComponent(p[1].replace(/\+/g, ' '))
    @_qs[param]


module.exports = Utils
