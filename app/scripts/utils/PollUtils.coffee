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

AppActions = require '../actions/AppActions'

{AuthConstants: {TOKEN_EXPIRATION_MS},
POLL_INTERVAL}  = require '../constants/PlannerConstants'


# Private
_interval = null

_performPoll = (userId, untTimestamp, now)->
  now ?= new Date().valueOf()
  if now > untTimestamp
    PollUtils.clear()
    AppActions.logout()
  else
    AppActions.updateSchedules userId

# TODO Test
class PollUtils

  @clear: ->
    clearInterval _interval

  @poll: (userId, {untTimestamp, pollInterval, pollFunc, now}={})->
    pollFunc     ?= _performPoll
    pollInterval ?= POLL_INTERVAL
    untTimestamp ?= new Date().valueOf() + TOKEN_EXPIRATION_MS
    _interval = setInterval(
      # OK because POLL_INTERVAL will always be sufficiently big
      pollFunc.bind(null, userId, untTimestamp, now), pollInterval
    )


module.exports = PollUtils
