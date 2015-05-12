
$                 = require 'jquery'
Factory           = require './Factory'
EventFactory      = require './EventFactory'
ApiUtils          = require '../utils/ApiUtils'
ScheduleStore     = require '../stores/ScheduleStore'
SectionStore      = require '../stores/SectionStore'
SectionColorStore = require '../stores/SectionColorStore'
EventStore        = require '../stores/EventStore'


# TODO Tests
class ScheduleFactory extends Factory

  _fields: {
    "id":             null
    "name":           null
    "studentId":      -> ApiUtils.currentStudent().id
    "schoolId":       -> ApiUtils.currentSchool().id
    "term":           -> ApiUtils.currentSchool().terms[0]
    "sectionIds":     null
    "sectionColors":  null
    "totalCredits":   null
    "totalSections":  null
    "events":         null
  }

  buildCurrent: (id)->
    schedule = ScheduleStore.current id
    events   = EventStore.eventsExceptDeleted(id).map (event)->
      EventFactory.create event

    $.extend true, {}, @create(
      id:             schedule.id
      name:           schedule.name
      studentId:      schedule.studentId
      schoolId:       schedule.schoolId
      term:           schedule.term
      sectionIds:     SectionStore.sections(id).map (sec)-> sec.id
      sectionColors:  SectionColorStore.colors id
      totalCredits:   SectionStore.credits id
      totalSections:  SectionStore.count id
      events:         events
    )


module.exports = new ScheduleFactory
