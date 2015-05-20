
Store         = require './Store'
DateUtils     = require '../utils/DateUtils'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_current = DateUtils.now()

class WeekStore extends Store

  currentWeekNumber: ->
    _current.week()

  currentWeekDate: ->
    _current

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.SET_WEEK
        _current = action.weekStart
        @emitChange()


module.exports = new WeekStore
