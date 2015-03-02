
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_preview = null

class PreviewStore extends Store

  getPreview: ->
    _preview

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.ADD_SECTION_PREVIEW
        _preview = action.section
        @emitChange()
      when ActionTypes.REMOVE_SECTION_PREVIEW
        _preview = null
        @emitChange()


module.exports = new PreviewStore
