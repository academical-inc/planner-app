

class ApiUtils

  @currentSchool: ->
    window.location.hostname.split(".")[1]

  @parse: (resp, xhr)->
    resp.data

module.exports = ApiUtils
