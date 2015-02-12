
Env            = require '../Env'
Academical     = require '../api/Academical'
PlannerActions = require '../actions/PlannerActions'

_api = new Academical
_api.setHost Env.API_HOST, Env.API_PROTOCOL


class ApiUtils

  @_errorHandle: (cb)->
    try
      cb()
    catch e
      # TODO Do this properly
      throw e
      switch e.type
        when "AcademicalApiError" then
          # Dispatch something relevant
        when "ConnectionError" then
          # Dispatch something relevant
        else
          # I don't know what to do :|

  @currentSchool: ->
    window.location.hostname.split(".")[1]

  @currentStudent: ->
    # TODO Implement properly from login
    "54dc48196d616337d5000000"

  @getAllSchedules: (studentId=ApiUtils.currentStudent())->
    ApiUtils._errorHandle ->
      _api.students.listSchedules studentId, (schedules)->
        PlannerActions.receiveSchedules schedules


module.exports = ApiUtils
