
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


_canvas = null

# TODO Test
class ExportStore extends Store

  canvas: ->
    _canvas

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.EXPORT_IMAGE_SUCCESS
        _canvas = action.canvas
        @emitChange()


module.exports = new ExportStore
