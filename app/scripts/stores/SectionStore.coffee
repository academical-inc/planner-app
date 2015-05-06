
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

removeSection = (sectionId)->
  removed = _.removeElement sectionId
  if removed?
    if removed.corequisites.length > 0
      removed.corequisites.forEach (coreq)->
        _.removeElement coreq.id
    else if removed.corequisiteOfId
      _.removeElement removed.corequisiteOfId


class SectionStore extends Store

  sections: ->
    _.currentElements

  sectionEvents: ->
    EventUtils.getSectionEvents _.currentElements

  credits: ->
    _.currentElements.reduce ((acum, section)-> acum + section.credits), 0.0

  count: ->
    _.currentElements.length

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        wait()
        _.setCurrent()
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        wait()
        _.initElementsMap action.schedules
        _.setCurrent()
        @emitChange()
      # TODO Tests
      when ActionTypes.UPDATE_SCHEDULES_SUCCESS
        wait()
        _.initElementsMap action.schedules
        _.setCurrent()
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        wait()
        _.addSchedule action.schedule.id
        _.setCurrent()
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        wait()
        _.removeSchedule action.scheduleId
        _.setCurrent()
        @emitChange()
      when ActionTypes.ADD_SECTION
        _.addElement action.section
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
