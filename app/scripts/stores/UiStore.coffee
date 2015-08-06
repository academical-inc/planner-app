
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
