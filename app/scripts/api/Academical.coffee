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

resources =
  Schools:   require './resources/Schools'
  Students:  require './resources/Students'
  Schedules: require './resources/Schedules'


class Academical

  @DEFAULT_HOST:       'academical-api-staging.herokuapp.com'
  @DEFAULT_PROTOCOL:   'https'
  @DEFAULT_BASE_PATH:  '/'
  @DEFAULT_TIMEOUT:    120000
  @DEFAULT_HEADERS: {
    "Content-Type": "application/json"
    "Accept": "application/json"
  }

  #TODO should add api key and auth when functionality available
  constructor: (resMap = resources)->
    @_api =
      auth:      null
      host:      Academical.DEFAULT_HOST
      protocol:  Academical.DEFAULT_PROTOCOL
      basePath:  Academical.DEFAULT_BASE_PATH
      timeout:   Academical.DEFAULT_TIMEOUT
      headers:   Academical.DEFAULT_HEADERS
      agent:     null
      dev:       false

    # Prepping resources
    @_prepResources resMap

  get: (field)->
    @_api[field]

  setHost: (host, protocol) ->
    @setProtocol protocol if protocol?
    @_set "host", host

  setProtocol: (protocol)->
    @_set "protocol", protocol

  setBasePath: (basePath)->
    @_set "basePath", basePath

  setHeaders: (headers)->
    @_set "headers", headers

  addHeaders: (headers)->
    @setHeaders $.extend(true, {}, @get("headers"), headers)

  setTimeout: (timeout)->
    @_set "timeout", timeout

  _set: (field, value)->
    @_api[field] = value
    return

  _prepResources: (resMap)->
    for name of resMap
      @[name.toLowerCase()] = new resMap[name](@)


module.exports = Academical
