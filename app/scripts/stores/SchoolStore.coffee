
Store         = require './Store'
DateUtils     = require '../utils/DateUtils'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_school = {}


class SchoolStore extends Store

  school: ->
    _school

  nowIsBeforeTermStart: ->
    DateUtils.now().week() < DateUtils.date(_school.terms[0].startDate).week()

  nowIsAfterTermEnd: ->
    DateUtils.now().week() > DateUtils.date(_school.terms[0].endDate).week()

  dispatchCallback: (payload)->
    action = payload.action

    switch action.type
      when ActionTypes.INIT_SCHOOL
        _school = action.school


module.exports = new SchoolStore
