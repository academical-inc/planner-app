
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


# Private


class UserStore extends Store

  isLoggedIn: ->
    true

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.SOME_ACTION
        # Do something
        @emitChange()


module.exports = new UserStore
