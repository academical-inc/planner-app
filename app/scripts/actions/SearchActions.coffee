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

_                 = require '../utils/Utils'
ActionUtils       = require '../utils/ActionUtils'
SearchUtils       = require '../utils/SearchUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{DebounceRates}   = require '../constants/PlannerConstants'


# Private
search = _.debounce (
  (query)->
    if query?
      PlannerDispatcher.dispatchViewAction
        type: ActionTypes.SEARCH
        query: query

      SearchUtils.search query, ActionUtils.handleServerResponse(
        ActionTypes.SEARCH_SUCCESS
        ActionTypes.SEARCH_FAIL
        (response)->
          query: query
          results: response
      )
    return
  ), DebounceRates.SEARCH_RATE


# TODO Test
class SearchActions

  @search: (query)->
    search query

  @clearSearch: ->
    SearchUtils.clearSearch()
    @search null
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CLEAR_SEARCH

  @toggleFilter: (added, name, value)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.TOGGLE_FILTER
      added: added
      name: name
      value: value

module.exports = SearchActions
