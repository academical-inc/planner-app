
_                 = require '../utils/Utils'
ActionUtils       = require '../utils/ActionUtils'
SearchUtils       = require '../utils/SearchUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{DebounceRates}   = require '../constants/PlannerConstants'


# Private
search = _.debounce (
  (query)->
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
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CLEAR_SEARCH

  @toggleFilter: (added, name, value)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.TOGGLE_FILTER
      added: added
      name: name
      value: value

module.exports = SearchActions
