
$           = require 'jquery'
Factory     = require './Factory'
ApiUtils    = require '../utils/ApiUtils'
SchoolStore = require '../stores/SchoolStore'


# TODO Tests
class ScheduleFactory extends Factory

  _fields: {
    "id":             null
    "name":           null
    "studentId":      -> ApiUtils.currentStudent().id
    "schoolId":       -> SchoolStore.school().id
    "term":           -> SchoolStore.school().terms[0]
    "sectionIds":     null
    "sectionColors":  {}
    "totalCredits":   null
    "totalSections":  null
    "events":         null
  }


module.exports = new ScheduleFactory
