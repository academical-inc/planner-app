
{EventEmitter}    = require 'events'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'

CHANGE_EVENT = "change"


class Store extends EventEmitter

  constructor: ->
    @dispatchToken = PlannerDispatcher.register @dispatchCallback

  emitChange: ->
    @emit CHANGE_EVENT

  addChangeListener: (cb)->
    @on CHANGE_EVENT, cb

  removeChangeListener: (cb)->
    @removeListener CHANGE_EVENT, cb


module.exports = Store
