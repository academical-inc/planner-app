#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

BrowserUtils = require './BrowserUtils'

transformKeys = (obj, func)->
  return null if not obj?
  if Array.isArray obj
    obj.map (el)-> transformKeys el, func
  else if typeof obj == 'object'
    resObj = {}
    for key of obj
      resObj[func(key)] = transformKeys obj[key], func
    resObj
  else
    obj

class Utils

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

  @uniq: (arr)->
    set = {}
    res = []
    for val in arr
      res.push val if not (set[val] is true)
      set[val] = true
    res

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
  # https://github.com/domchristie/humps/blob/master/humps.js#L49
  @camelized: (str)->
    str = str.replace /[\-_\s]+(.)?/g, (match, chr)->
      if chr then chr.toUpperCase() else ''
    # Ensure 1st char is always lowercase
    str.replace /^([A-Z])/, (match, chr)->
      if chr then chr.toLowerCase() else ''

  # TODO Test
  @camelizedKeys: (obj)->
    transformKeys obj, @camelized

  # TODO Test
  # https://github.com/epeli/underscore.string
  @underscored: (str)->
    str.trim().replace(/([a-z\d])([A-Z]+)/g, '$1_$2').\
      replace(/[-\s]+/g, '_').toLowerCase()

  # TODO Test
  @underscoredKeys: (obj)->
    transformKeys obj, @underscored

Utils = $.extend {}, Utils, BrowserUtils
module.exports = Utils
