
Resource = require '../Resource'


class Students extends Resource

  path: "students"

  retrieve: Resource.createApiCall
    method: "get"
    path: "{id}"
    requiredParams: ["id"]


module.exports = Students
