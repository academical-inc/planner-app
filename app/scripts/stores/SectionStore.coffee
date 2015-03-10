
$                 = require 'jquery'
Store             = require './Store'
ScheduleStore     = require './ScheduleStore'
HelperUtils       = require '../utils/HelperUtils'
EventUtils        = require '../utils/EventUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
_                = $.extend true, {}, HelperUtils, EventUtils
_sectionsMap     = {}
_currentSections = []


setSectionsMap = (schedules)->
  schedules.forEach (schedule)->
    _sectionsMap[schedule.id] = schedule.sections

setCurrent = (scheduleId)->
  _currentSections = _sectionsMap[scheduleId]

addSchedule = (scheduleId)->
  _sectionsMap[scheduleId] = []

removeSchedule = (scheduleId)->
  delete _sectionsMap[scheduleId]

addSection = (section)->
  _currentSections.push section

removeSection = (sectionId)->
  section = _.findAndRemove _currentSections, (section)->
    section.id == sectionId


class SectionStore extends Store

  sections: ->
    _currentSections

  sectionEvents: ->
    _.getSectionEvents _currentSections

  credits: ->
    _currentSections.reduce ((acum, section)-> acum + section.credits), 0.0

  count: ->
    _currentSections.length

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        setSectionsMap action.schedules
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        addSchedule action.schedule.id
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        removeSchedule action.scheduleId
        setCurrent ScheduleStore.current().id
        @emitChange()
      when ActionTypes.ADD_SECTION
        addSection action.section
        @emitChange()
      when ActionTypes.REMOVE_SECTION
        removeSection action.sectionId
        @emitChange()


module.exports = new SectionStore
