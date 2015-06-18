
$          = require 'jquery'
Env        = require '../Env'
UserStore  = require '../stores/UserStore'
Academical = require '../api/Academical'

# Private
_api = null

class ApiUtils

  @init: ()->
    # TODO Should probably init current student and school here
    _api = new Academical
    _api.setHost Env.API_HOST, Env.API_PROTOCOL
    UserStore.addChangeListener ->
      authToken = UserStore.authToken()
      _api.addHeaders "Authorization": "Bearer #{authToken}" if authToken?

  @fetchUser: (user, cb)->
    _api.students.create user, cb

  @getSchedules: (userId, cb)->
    _api.students.listSchedules userId,
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
