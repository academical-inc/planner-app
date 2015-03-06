
Store             = require './Store'
ScheduleStore     = require './ScheduleStore'
_                 = require '../utils/HelperUtils'
EventUtils        = require '../utils/EventUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


# Private
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
  _.findAndRemove _currentSections, (section)-> section.id == sectionId


class SectionStore extends Store

  getCurrentSections: ->
    _currentSections

  getCurrentSectionEvents: ->
    EventUtils.getSectionEvents _currentSections

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
