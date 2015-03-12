
Env        = require '../Env'
_          = require '../utils/DateUtils'
Academical = require '../api/Academical'

_api                   = null
_currentSchoolNickname = null
_currentSchool         = null
_hostname              = window.location.hostname

# TODO Implement properly from login
_currentStudent = id: "54e4f2386d61635e22050000"
# _currentStudent = id: "54dc48196d616337d5000000"


class ApiUtils

  @init: ->
    # TODO Should probably init current student and school here
    _api = new Academical
    _api.setHost Env.API_HOST, Env.API_PROTOCOL
    _currentSchoolNickname = _hostname.split(".")[0]

  @data:
    scheduleToUpdate: ->
      _api.data.scheduleToUpdate arguments...
    newSchedule: (name, {studentId, schoolId, term}={})->
      studentId ?= _currentStudent.id
      schoolId  ?= _currentSchool.id
      term      ?= _currentSchool.terms[0]

      _api.data.newSchedule(
        name
        studentId
        schoolId
        term
      )
    newEvent: (name, startDt, endDt, days, {to ,timezone, location, \
        description, color}={})->
      if not to?
        termEnd = _.utcFromStr _currentSchool.terms[0].endDate, "YYYY-MM-DD"
        to = _.setTime termEnd, startDt, _currentSchool.utcOffset
        to = _.format _.toUtc(to)

      timezone ?= _currentSchool.timezone
      _api.data.newEvent(
        name
        _.format _.toUtc(startDt)
        _.format _.toUtc(endDt)
        timezone
        days: days
        to: to
        location: location
        description: description
        color: color
      )


  @api = _api

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
