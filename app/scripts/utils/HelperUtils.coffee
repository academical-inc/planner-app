

class HelperUtils

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
      return null if not val[part]
      val = val[part]
    val

  @setNested: (obj, key, val)->
    parts = key.split(".")
    last  = parts[parts.length-1]
    parts[...-1].forEach (part)->
      obj[part] = {} if not obj[part]?
      obj = obj[part]
    obj[last] = val

  @objFilter: (obj, keys, test=->true)->
    keyList  = if Array.isArray(keys) then keys else Object.keys(keys)
    filtered = {}

    for key in keyList
      val    = @getNested obj, key
      defVal = keys[key]
      if val? and test(val)
        @setNested filtered, key, val
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



module.exports = HelperUtils
