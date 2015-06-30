
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_results   = []
_query     = ""
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
        _results   = []
        @emitChange()
      when ActionTypes.SEARCH_SUCCESS
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
