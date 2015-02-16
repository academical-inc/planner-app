
Env            = require '../Env'
Academical     = require '../api/Academical'

_api = new Academical

# TODO Implement properly from login
_currentStudent = id: "54dc48196d616337d5000000"
_currentSchool  =
  id: "5480f2ed3334370008000000"
  nickname: window.location.hostname.split(".")[1]
  term:
    name:      "first"
    startDate: Date.parse "2015-01-01"
    endDate:   Date.parse "2015-05-01"


class ApiUtils

  @init: ->
    # TODO Should probably init current student and school here
    _api.setHost Env.API_HOST, Env.API_PROTOCOL

  @data:
    newSchedule: (name, {studentId, schoolId, term}={})->
      studentId ?= _currentStudent.id
      schoolId  ?= _currentSchool.id
      term      ?= _currentSchool.term

      _api.data.newSchedule(
        name
        studentId
        schoolId
        term
      )

  @api = _api

  # TODO Implement properly from login
  @currentSchool: _currentSchool

  # TODO Implement properly from login
  @currentStudent: _currentStudent

  @getSchedules: (cb, studentId=_currentStudent.id)->
    _api.students.listSchedules studentId, cb

  @createSchedule: (schedule, cb)->
    _api.schedules.create schedule, cb


module.exports = ApiUtils
