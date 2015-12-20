
Store          = require './Store'
SectionStore   = require './SectionStore'
DateUtils      = require '../utils/DateUtils'
EventUtils     = require '../utils/EventUtils'
{ActionTypes}  = require '../constants/PlannerConstants'
{PreviewTypes} = require '../constants/PlannerConstants'


# Private
class Preview
  constructor: (@section=null, @events=[])->

_previews = {}
_previews[PreviewTypes.PRIMARY] = new Preview
_previews[PreviewTypes.SECONDARY] = new Preview
_isOverlapping = false


areSameWeekday = (dt1, dt2)->
  dt1.weekday() is dt2.weekday()

areSameMonthAndDay = (dt1, dt2)->
  dt1.month() is dt2.month() and dt1.date() is dt2.date()

areOverlapping = (ev1, ev2)->
  ev1St = DateUtils.date(ev1.startDt)
  ev2St = DateUtils.date(ev2.startDt)
  return false unless areSameWeekday(ev1St, ev2St)

  ev1En = DateUtils.date(ev1.endDt)
  ev2En = DateUtils.date(ev2.endDt)
  if not areSameMonthAndDay(ev1St, ev2St)
    ev2St = DateUtils.setDate(ev2St, newDate: ev1St)
    ev2En = DateUtils.setDate(ev2En, newDate: ev1En)

  not (ev1St.valueOf() >= ev2En.valueOf() or ev1En.valueOf() <= ev2St.valueOf())

anyOverlapping = (previewEvents, allSectionEvents)->
  previewEventsLen = previewEvents.length
  allEventsLen = allSectionEvents.length

  i = previewEventsLen
  while i--
    prevEv = previewEvents[previewEventsLen - 1 - i]
    j = allEventsLen
    while j--
      secEv = allSectionEvents[allEventsLen - 1 - j]
      if areOverlapping(prevEv, secEv)
        return true

  return false


addPreview = (previewType, section)->
  _isOverlapping    = false
  section.expanded ?= EventUtils.expandEvents section, section.events

  _previews[previewType].section = section
  _previews[previewType].events  = section.expanded

  previewEvents  = section.events
  sectionEvents  = EventUtils.concatEvents SectionStore.sections()
  _isOverlapping = anyOverlapping previewEvents, sectionEvents

removePreview = (previewType)->
  _previews[previewType] = new Preview


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
