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
_results   = []
_query     = ""
_latest    = null
_searching = false

# TODO Test
class SearchStore extends Store

  results: ->
    _results

  query: ->
    _query

  searching: ->
    _searching

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.SEARCH
        _searching = true
        _query     = action.query
        _latest    = action.query
        _results   = []
        @emitChange()
      when ActionTypes.SEARCH_SUCCESS
        if action.query is _latest
          _searching = false
          _results = action.results
          _query   = action.query
          @emitChange()
      when ActionTypes.CLEAR_SEARCH
        _searching = false
        _query     = null
        _results   = []
        @emitChange()

module.exports = new SearchStore
