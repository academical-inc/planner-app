
Store         = require './Store'
SectionStore  = require './SectionStore'
EventUtils    = require '../utils/EventUtils'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_preview = null
_previewEvents = []
_isOverlapping = false

areOverlapping = (ev1, ev2)->
  ev1St = Date.parse ev1.startDt
  ev1En = Date.parse ev1.endDt
  ev2St = Date.parse ev2.startDt
  ev2En = Date.parse ev2.endDt
  not (ev1St >= ev2En or ev1En <= ev2St)

anyOverlapping = (previewEvents, allSectionEvents)->
  previewEvents.forEach (prevEv)->
    allSectionEvents.forEach (secEv)->
      if areOverlapping prevEv.event, secEv.event
        prevEv.event.isOverlapping = true
        _isOverlapping = true
  previewEvents

addPreview = (section)->
  _preview = section
  prevEvents = EventUtils.getSectionEvents [_preview]
  sectionEvents = SectionStore.sectionEvents()
  _previewEvents = anyOverlapping prevEvents, sectionEvents

removePreview = ->
  _preview = null
  _previewEvents = []
  _isOverlapping = false


class PreviewStore extends Store

  preview: ->
    _preview

  previewEvents: ->
    _previewEvents

  isOverlapping: ->
    _isOverlapping

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.ADD_SECTION_PREVIEW
        addPreview action.section
        @emitChange()
      when ActionTypes.REMOVE_SECTION_PREVIEW
        removePreview()
        @emitChange()


module.exports = new PreviewStore
