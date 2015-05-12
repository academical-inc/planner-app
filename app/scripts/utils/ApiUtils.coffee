
$          = require 'jquery'
Env        = require '../Env'
_          = require '../utils/DateUtils'
Academical = require '../api/Academical'

_api                   = null
_currentSchoolNickname = null
_currentSchool         = null
_hostname              = window.location.hostname

# TODO Implement properly from login
_currentStudent = id: "5501ec676d616308f5000000"
# _currentStudent = id: "552edf8b6d6163c2b1000000"


class ApiUtils

  @api = _api

  @init: ->
    # TODO Should probably init current student and school here
    _api = new Academical
    _api.setHost Env.API_HOST, Env.API_PROTOCOL
    _currentSchoolNickname = _hostname.split(".")[0]

  # TODO Implement properly from login
  @currentSchool: -> _currentSchool

  # TODO Implement properly from login
  @currentStudent: -> _currentStudent

  @initSchool: (cb, nickname=_currentSchoolNickname)->
    _api.schools.retrieve nickname, (error, school)->
      _currentSchool = school if not error?
      cb error, school

  @getSchedules: (cb, studentId=_currentStudent.id)->
    _api.students.listSchedules studentId,
      includeSections: true,
      expandEvents: true,
      cb

  @createSchedule: (schedule, cb)->
    _api.schedules.create schedule, cb

  @deleteSchedule: (scheduleId, cb)->
    _api.schedules.del scheduleId, cb

  @saveSchedule: (scheduleId, toSave, cb)->
    _api.schedules.update scheduleId,
      data: toSave,
      params:
        includeSections: true
        expandEvents: true
      cb

module.exports = ApiUtils
