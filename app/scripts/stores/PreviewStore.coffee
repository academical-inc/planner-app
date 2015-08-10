
Store          = require './Store'
SectionStore   = require './SectionStore'
EventUtils     = require '../utils/EventUtils'
{ActionTypes}  = require '../constants/PlannerConstants'
{PreviewTypes} = require '../constants/PlannerConstants'


# Private
class Preview
  constructor: (@section=null, @events=[])->

_previews = {}
_previews[PreviewTypes.PRIMARY] = new Preview
_previews[PreviewTypes.SECONDARY] = new Preview
_isOverlapping   = false


areOverlapping = (ev1, ev2)->
  ev1St = Date.parse ev1.startDt
  ev1En = Date.parse ev1.endDt
  ev2St = Date.parse ev2.startDt
  ev2En = Date.parse ev2.endDt
  not (ev1St >= ev2En or ev1En <= ev2St)

anyOverlapping = (prevEvents, allSectionEvents)->
  prevEvents.forEach (prevEv)->
    prevEv.isOverlapping = false
    allSectionEvents.forEach (secEv)->
      if areOverlapping prevEv, secEv
        prevEv.isOverlapping = true
        _isOverlapping = true
  prevEvents

previewEvents = (section)->
  section.expanded ?= EventUtils.expandEvents section, section.events
  sectionEvents = SectionStore.sectionEvents()
  anyOverlapping section.expanded, sectionEvents

addPreview = (previewType, section)->
  _previews[previewType].section = section
  _previews[previewType].events  = previewEvents section

removePreview = (previewType)->
  _previews[previewType] = new Preview
  _isOverlapping = false


class PreviewStore extends Store

  primary: ->
    _previews[PreviewTypes.PRIMARY].section

  primaryEvents: ->
    _previews[PreviewTypes.PRIMARY].events

  secondary: ->
    _previews[PreviewTypes.SECONDARY].section

  secondaryEvents: ->
    _previews[PreviewTypes.SECONDARY].events

  allPreviewEvents: ->
    @primaryEvents().concat @secondaryEvents()

  isOverlapping: ->
    _isOverlapping

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.ADD_SECTION_PREVIEW
        addPreview action.previewType, action.section
        @emitChange()
      when ActionTypes.REMOVE_SECTION_PREVIEW
        removePreview action.previewType
        @emitChange()


module.exports = new PreviewStore
