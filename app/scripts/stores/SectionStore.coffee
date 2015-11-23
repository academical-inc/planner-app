
Store             = require './Store'
ScheduleStore     = require './ScheduleStore'
SectionColorStore = require './SectionColorStore'
ChildStoreHelper  = require '../utils/ChildStoreHelper'
EventUtils        = require '../utils/EventUtils'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_ = new ChildStoreHelper(ScheduleStore, 'sections')

wait = ->
  _.wait [SectionColorStore.dispatchToken]

expandSectionEvents = (sec)->
  sec.expanded = EventUtils.expandEvents sec, sec.events if not sec.expanded?

expandCurrent = ->
  _.currentElements.forEach expandSectionEvents

setCurrent = ->
  _.setCurrent()
  expandCurrent()

removeSection = (sectionId)->
  removed = _.removeElement sectionId
  if removed?
    if removed.corequisites? and removed.corequisites.length > 0
      removed.corequisites.forEach (coreq)->
        _.removeElement coreq.id
    else if removed.corequisiteOfId?
      _.removeElement removed.corequisiteOfId


# TODO Test Event expansion
class SectionStore extends Store

  sections: (id)->
    _.currentElementsOr(id) or []

  sectionEvents: (id)->
    EventUtils.concatExpandedEvents @sections(id)

  credits: (id)->
    @sections(id).reduce ((acum, section)-> acum + section.credits), 0.0

  count: (id)->
    @sections(id).length

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        wait()
        setCurrent()
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS, \
           ActionTypes.UPDATE_SCHEDULES_SUCCESS
        wait()
        _.initElementsMap action.schedules
        setCurrent()
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        wait()
        _.updateSchedule action.schedule
        setCurrent()
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        wait()
        _.removeSchedule action.scheduleId
        setCurrent()
        @emitChange()
      when ActionTypes.ADD_SECTION
        _.addElement action.section
        expandSectionEvents action.section
        @emitChange()
      when ActionTypes.REMOVE_SECTION
        removeSection action.sectionId
        @emitChange()
      when ActionTypes.SAVE_SCHEDULE_SUCCESS
        # TODO
        wait()
      when ActionTypes.SAVE_SCHEDULE_FAIL
        # TODO
        wait()

module.exports = new SectionStore
