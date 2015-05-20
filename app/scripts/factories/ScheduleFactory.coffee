
$                 = require 'jquery'
Factory           = require './Factory'
ApiUtils          = require '../utils/ApiUtils'


# TODO Tests
class ScheduleFactory extends Factory

  _fields: {
    "id":             null
    "name":           null
    "studentId":      -> ApiUtils.currentStudent().id
    "schoolId":       -> ApiUtils.currentSchool().id
    "term":           -> ApiUtils.currentSchool().terms[0]
    "sectionIds":     null
    "sectionColors":  {}
    "totalCredits":   null
    "totalSections":  null
    "events":         null
  }


module.exports = new ScheduleFactory
