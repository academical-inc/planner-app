
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_current = null

class CurrentWeekStore extends Store

  week: ->
    _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.CHANGE_WEEK
        _current = action.weekStart.week()
        @emitChange()


module.exports = new CurrentWeekStore
