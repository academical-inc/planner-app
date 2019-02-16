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

class BrowserUtils

  @_qs: null
  @_hs: null

  @isMac: ->
    navigator.platform.indexOf("Mac") != -1

  @openWindow: (url)->
    console.log url
    window.open(url, "facebook_share_dialog")

  @parseArgumentString: (argumentString)->
    hash = {}
    if argumentString
      params = argumentString.substr(1).split('&')
      for val in params
        p = val.split '=', 2
        if p.length == 1
          hash[p[0]] = ''
        else
          hash[p[0]] = decodeURIComponent(p[1].replace(/\+/g, ' '))
    hash

  @qs: (param, queryStr=window.location.search)->
    if not @_qs?
      @_qs = @parseArgumentString(queryStr)
    @_qs[param]

  @hs : (param, hashStr=window.location.hash)->
    if not @_hs?
      @_hs = @parseArgumentString(hashStr)
    @_hs[param]

  @origin: ->
    origin = window.location.origin
    if !origin
      origin = window.location.protocol + '//' + window.location.hostname
      origin += (':' + window.location.port ) if window.location.port
    origin

module.exports = BrowserUtils
