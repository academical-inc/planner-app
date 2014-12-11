

class ApiUtils

  @currentSchool: ->
    window.location.hostname.split(".")[1]

  @currentStudent: ->
    # TODO Implement properly from login
    "5489cbf46d616371d4140000"


module.exports = ApiUtils
