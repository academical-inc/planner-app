
Factory     = require './Factory'
SchoolStore = require '../stores/SchoolStore'
UserStore   = require '../stores/UserStore'

# TODO Tests
class ScheduleFactory extends Factory

  _fields: {
    "id":             null
    "name":           null
    "studentId":      -> UserStore.user().id
    "schoolId":       -> SchoolStore.school().id
    "term":           -> SchoolStore.school().terms[0]
    "sectionIds":     null
    "sectionColors":  {}
    "totalCredits":   null
    "totalSections":  null
    "events":         null
  }


module.exports = new ScheduleFactory
