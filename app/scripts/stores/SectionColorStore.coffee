
Store            = require './Store'
ScheduleStore    = require './ScheduleStore'
ChildStoreHelper = require '../utils/ChildStoreHelper'
{ActionTypes}    = require '../constants/PlannerConstants'


# Private
_ = new ChildStoreHelper(ScheduleStore, 'sectionColors')


# TODO Revisit this design
# TODO Tests
class SectionColorStore extends Store

  colors: (id)->
    _.currentElementsOr id

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        _.wait()
        _.setCurrent()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        _.wait()
        _.initElementsMap action.schedules
        _.setCurrent()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        _.wait()
        _.addSchedule action.schedule.id, {}
        _.setCurrent()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        _.wait()
        _.removeSchedule action.scheduleId
        _.setCurrent()
      when ActionTypes.ADD_SECTION
        _.currentElements[action.section.id] = action.color
      when ActionTypes.REMOVE_SECTION
        delete _.currentElements[action.sectionId]
      when ActionTypes.CHANGE_SECTION_COLOR
        _.currentElements[action.sectionId] = action.color
        @emitChange()


module.exports = new SectionColorStore
