
$          = require 'jquery'
Env        = require '../Env'
Academical = require '../api/Academical'

_api                   = null

# TODO Implement properly from login
_currentStudent = id: "5501ec676d616308f5000000"
# _currentStudent = id: "552edf8b6d6163c2b1000000"


class ApiUtils

  @api = _api

  @init: ->
    # TODO Should probably init current student and school here
    _api = new Academical
    _api.setHost Env.API_HOST

  # TODO Implement properly from login
  @currentStudent: -> _currentStudent

  @getSchedules: (cb, studentId=_currentStudent.id)->
    _api.students.listSchedules studentId,
      includeSections: true,
      expandEvents: true,
      cb

  @getSchedule: (scheduleId, cb, params={})->
    params = $.extend(
      true, {includeSections: true, expandEvents: true}, params
    )
    _api.schedules.retrieve scheduleId,
      params
      cb

  @createSchedule: (schedule, cb)->
    _api.schedules.create
      data: schedule
      params:
        includeSections: true
        expandEvents: true
      cb

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
