
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'


# Private
_school = {}


class SchoolStore extends Store

  school: ->
    _school

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.INIT_SCHOOL
        _school = action.school


module.exports = new SchoolStore
