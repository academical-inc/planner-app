
_                 = require '../utils/HelperUtils'
ActionUtils       = require '../utils/ActionUtils'
SearchUtils       = require '../utils/SearchUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
search = _.debounce (query)->
  SearchUtils.search query, ActionUtils.handleServerResponse(
    ActionTypes.SEARCH_SUCCESS
    ActionTypes.SEARCH_FAIL
    (response)->
      query: query
      results: response
  ),
  100


# TODO Test
class SearchActions

  @search: (query)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.SEARCH
      query: query

    search query


module.exports = SearchActions
