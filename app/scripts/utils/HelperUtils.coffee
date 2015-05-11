

class HelperUtils

  @find: (arr, test)->
    for val in arr
      return val if test val
    return null

  @findWithIdx: (arr, test)->
    for val, idx in arr
      return [val, idx] if test val
    return [null, null]

  @filter: (arr, test)->
    (val for val in arr when test(val))

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

  @objFilter: (obj, keys, test=->true)->
    keyList  = if Array.isArray(keys) then keys else Object.keys(keys)
    filtered = {}

    for key in keyList
      if obj.hasOwnProperty(key) and test(obj[key])
        filtered[key] = obj[key]
      else if keys[key]?
        filtered[key] = if typeof keys[key] == 'function'
          keys[key]()
        else
          keys[key]
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
