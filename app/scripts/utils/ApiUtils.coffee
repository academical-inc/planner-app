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

$          = require 'jquery'
Env        = require '../Env'
UserStore  = require '../stores/UserStore'
Academical = require '../api/Academical'

# Private
_api = null

class ApiUtils

  @init: ()->
    # TODO Should probably init current student and school here
    _api = new Academical
    _api.setHost Env.API_HOST, Env.API_PROTOCOL
    UserStore.addChangeListener ->
      authToken = UserStore.authToken()
      _api.addHeaders "Authorization": "Bearer #{authToken}" if authToken?

  @fetchUser: (user, cb)->
    _api.students.create user, cb

  @getSchedules: (userId, cb)->
    _api.students.listSchedules userId, cb

  @getSchedule: (scheduleId, cb, params={})->
    _api.schedules.retrieve scheduleId,
      params
      cb

  @createSchedule: (schedule, cb)->
    _api.schedules.create schedule, cb

  @deleteSchedule: (scheduleId, cb)->
    _api.schedules.del scheduleId, cb

  @saveSchedule: (scheduleId, toSave, cb)->
    _api.schedules.update scheduleId, toSave, cb

module.exports = ApiUtils
