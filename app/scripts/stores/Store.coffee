
{EventEmitter} = require 'events'

CHANGE_EVENT = "change"


class Store extends EventEmitter

  emitChange: ->
    @emit CHANGE_EVENT

  addChangeListener: (cb)->
    @on CHANGE_EVENT, cb

  removeChangeListener: (cb)->
    @removeListener CHANGE_EVENT, cb


module.exports = Store
