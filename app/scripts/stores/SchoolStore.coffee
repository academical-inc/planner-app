
LsCache   = require 'lscache'
BaseModel = require './BaseModel'
Config    = require '../config'


EXPIRE_MINS = 10080  # 1 week

class School extends BaseModel

  url: ->
    "schools/#{encodeURIComponent(@get("nickname"))}"


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
