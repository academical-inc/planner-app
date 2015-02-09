
Resource = require '../Resource'


class Schedules extends Resource

  path: "schedules"

  create: Resource.createApiCall
    method: "get"

  update: Resource.createApiCall
    method: "put"
    path: "{id}"
    requiredParams: ["id"]

  del: Resource.createApiCall
    method: "delete"
    path: "{id}"
    requiredParams: ["id"]


module.exports = Schedules

