
Resource = require '../Resource'


class Students extends Resource

  path: "students"

  create: Resource.createApiCall
    method: "post"

  retrieve: Resource.createApiCall
    method: "get"
    path: "{id}"
    requiredParams: ["id"]

  listSchedules: Resource.createApiCall
    method: "get"
    path: "{id}/schedules"
    requiredParams: ["id"]


module.exports = Students
