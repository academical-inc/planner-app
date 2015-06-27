
Store         = require './Store'
SchoolStore   = require './SchoolStore'
_             = require '../utils/Utils'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_results   = []
_query     = ""
_searching = false
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
class SearchStore extends Store

  results: ->
    _results

  query: ->
    _query

  searching: ->
    _searching

  filters: ->
    _filters

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.SEARCH
        _searching = true
        _query     = action.query
        _results   = []
        @emitChange()
      when ActionTypes.SEARCH_SUCCESS
        _searching = false
        _results = action.results
        _query   = action.query
        @emitChange()
      when ActionTypes.TOGGLE_FILTER
        toggleFilter action.added, action.name, action.value

module.exports = new SearchStore
