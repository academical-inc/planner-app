
Store          = require './Store'
SectionStore   = require './SectionStore'
_              = require '../utils/DateUtils'
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


haveOverlappingDates = (ev1StDt, ev1EnDt, ev2StDt, ev2EnDt)->
  ev1EnDt ?= _.date(ev1StDt)
  ev2EnDt ?= _.date(ev2StDt)
  ev1StDt  = _.date(ev1StDt).startOf('day')
  ev2StDt  = _.date(ev2StDt).startOf('day')
  ev1EnDt  = _.date(ev1EnDt).startOf('day')
  ev2EnDt  = _.date(ev2EnDt).startOf('day')

  return not ((ev1StDt.isAfter(ev2EnDt) or ev1StDt.isSame(ev2EnDt)) or
              (ev1EnDt.isBefore(ev2StDt) or ev1EnDt.isSame(ev2StDt)))

areOverlapping = (ev1, ev2)->
  ev1St = _.date(ev1.startDt)
  ev2St = _.date(ev2.startDt)
  return false unless haveOverlappingDates(
    ev1St,
    ev1.recurrence?.repeatUntil,
    ev2St,
    ev2.recurrence?.repeatUntil
  )
  ev1En = _.date(ev1.endDt)
  ev2En = _.date(ev2.endDt)
  for day in ev1.recurrence.daysOfWeek
    if day in ev2.recurrence.daysOfWeek
      t1St = _.setTime(_.date(), ev1St)
      t1En = _.setTime(_.date(), ev1En)
      t2St = _.setTime(_.date(), ev2St)
      t2En = _.setTime(_.date(), ev2En)
      overlap = not (t1St.valueOf() >= t2En.valueOf() or
                     t1En.valueOf() <= t2St.valueOf())
      return true if overlap
  return false

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
