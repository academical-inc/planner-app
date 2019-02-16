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
_             = require '../utils/Utils'
SchoolStore   = require './SchoolStore'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_filters   = []

currentFor = (field)->
  _.findWithIdx _filters, (f)-> f[field]?

toggleFilter = (added, name, value)->
  {appUi: {searchFilters}} = SchoolStore.school()
  filter = _.find searchFilters, (f)-> f.name is name
  field  = filter.field
  if filter?
    [current, idx] = currentFor field
    switch filter.type
      when "values"
        if current?
          if added
            vals = current[field]
            vals.push value
            current[field] = _.uniq vals
          else
            _.findAndRemove current[field], (v)-> v is value
            if current[field].length is 0
              _.removeAt _filters, idx
        else
          if added
            current = {}
            current[field] = [value]
            _filters.push current
      when "boolean"
        if added and not current?
          current = {}
          current[field] = filter.condition
          _filters.push current
        else if not added and current?
          _.removeAt _filters, idx


# TODO Test
class SearchFiltersStore extends Store

  filters: ->
    _filters

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.TOGGLE_FILTER
        toggleFilter action.added, action.name, action.value
        @emitChange()


module.exports = new SearchFiltersStore
