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

Store         = require './Store'
DateUtils     = require '../utils/DateUtils'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_current = DateUtils.now()

class WeekStore extends Store

  currentWeekNumber: ->
    _current.week()

  currentWeekDate: ->
    _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.SET_WEEK
        _current = action.weekStart
        @emitChange()


module.exports = new WeekStore
