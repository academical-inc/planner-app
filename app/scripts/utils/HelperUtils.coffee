

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


module.exports = HelperUtils
