
Store         = require './Store'
DateUtils     = require '../utils/DateUtils'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_current = DateUtils.now()

class CurrentWeekStore extends Store

  week: ->
    _current.week()

  weekDate: ->
    _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.CHANGE_WEEK
        _current = action.weekStart
        @emitChange()


module.exports = new CurrentWeekStore
