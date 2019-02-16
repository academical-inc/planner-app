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
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_scheduleList = false
_optionsMenu  = false

# TODO Test and Improve
class UiStore extends Store

  scheduleList: ->
    _scheduleList

  optionsMenu: ->
    _optionsMenu

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.TOGGLE_SCHEDULE_LIST
        _scheduleList = !_scheduleList
        @emitChange()
      when ActionTypes.TOGGLE_OPTIONS_MENU
        _optionsMenu = !_optionsMenu
        @emitChange()


module.exports = new UiStore
