
LsCache   = require 'lscache'
Backbone  = require 'backbone'
Config    = require '../config'
ApiUtils  = require '../utils/ApiUtils'


EXPIRE_MINS = 10080  # 1 week

class School extends Backbone.Model

  url: ->
    "schools/#{encodeURIComponent(@get("nickname"))}"

  parse: ApiUtils.parse


class SchoolStore

  @init: (current, {success, error, complete}={})->
    attrs   = LsCache.get current
    if attrs?
      @_school = new School attrs
      success @_school
      complete()
    else
      school = new School nickname: current
      school.fetch
        success: (model)=>
          LsCache.set current, school.attributes, EXPIRE_MINS
          @_school = school
          success @_school
        error: error
        complete: complete

  @get: (attr)->
    @_school.get attr if @_school?


window.lscache = LsCache if Config.env.isDevelopment()
module.exports = SchoolStore
