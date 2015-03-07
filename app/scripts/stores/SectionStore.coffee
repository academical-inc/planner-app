
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
_credits         = 0.0


setSectionsMap = (schedules)->
  schedules.forEach (schedule)->
    _sectionsMap[schedule.id] = schedule.sections

setCurrent = (schedule)->
  _currentSections = _sectionsMap[schedule.id]
  _credits = schedule.totalCredits

addSchedule = (scheduleId)->
  _sectionsMap[scheduleId] = []

removeSchedule = (scheduleId)->
  delete _sectionsMap[scheduleId]

addSection = (section)->
  _currentSections.push section
  _credits += section.credits

removeSection = (sectionId)->
  sec = _.findAndRemove _currentSections, (section)-> section.id == sectionId
  _credits -= sec.credits


class SectionStore extends Store

  sections: ->
    _currentSections

  sectionEvents: ->
    _.getSectionEvents _currentSections

  credits: ->
    _credits

  sectionCount: ->
    _currentSections.length

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        setCurrent ScheduleStore.getCurrent().id
        @emitChange()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        setSectionsMap action.schedules
        setCurrent ScheduleStore.getCurrent().id
        @emitChange()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        addSchedule action.schedule.id
        setCurrent ScheduleStore.getCurrent().id
        @emitChange()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        PlannerDispatcher.waitFor [ScheduleStore.dispatchToken]
        removeSchedule action.scheduleId
        setCurrent ScheduleStore.getCurrent().id
        @emitChange()
      when ActionTypes.ADD_SECTION
        addSection action.section
        @emitChange()
      when ActionTypes.REMOVE_SECTION
        removeSection action.sectionId
        @emitChange()


module.exports = new SectionStore
