
$          = require 'jquery'
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
    scheduleToUpdate: (name, credits, sections, events, sectionColors)->
      events = events.map (event)->
        ev = $.extend {}, true, event
        delete ev.expanded    if ev.expanded?
        delete ev.dirtyAdd    if ev.dirtyAdd?
        delete ev.dirtyUpdate if ev.dirtyUpdate?
        ev
      _api.data.scheduleToUpdate name, credits, sections, events, sectionColors
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
    newEvent: (name, startDt, endDt, days, {repeatUntil ,timezone, location, \
        description, color}={})->
      if not repeatUntil?
        termEnd = _.utcFromStr _currentSchool.terms[0].endDate, "YYYY-MM-DD"
        repeatUntil = _.setTimeAndFormat(
          termEnd, startDt, _currentSchool.utcOffset
        )

      timezone ?= _currentSchool.timezone
      _api.data.newEvent(
        name
        _.format startDt
        _.format endDt
        timezone
        days: days
        repeatUntil: repeatUntil
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
