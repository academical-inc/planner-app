
$           = require 'jquery'
Factory     = require './Factory'
SchoolStore = require '../stores/SchoolStore'


# TODO Tests
class UserFactory extends Factory

  _fields: {
    "id":          null
    "auth0UserId": null
    "email":       null
    "name":        null
    "picture":     null
    "schoolId":    -> SchoolStore.school().id
  }


module.exports = new UserFactory
