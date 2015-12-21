
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class UiActions

  @toggleScheduleList: (startDt, endDt)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.TOGGLE_SCHEDULE_LIST

  @toggleOptionsMenu: (startDt, endDt)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.TOGGLE_OPTIONS_MENU

  @hideSearchResults: ->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CLEAR_SEARCH


module.exports = UiActions
