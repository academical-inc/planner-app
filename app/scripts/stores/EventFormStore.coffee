
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_start = null
_end   = null


class EventFormStore extends Store

  getStartEnd: ->
    [_start, _end]

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_EVENT_FORM
        _start = action.startDt
        _end   = action.endDt
        @emitChange()


module.exports = new EventFormStore
