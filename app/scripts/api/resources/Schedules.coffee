
Resource = require '../Resource'


class Schedules extends Resource

  path: "schedules"

  retrieve: Resource.createApiCall
    method: "get"
    path: "{id}"
    requiredParams: ["id"]

  create: Resource.createApiCall
    method: "post"

  update: Resource.createApiCall
    method: "put"
    path:   "{id}"
    requiredParams: ["id"]

  del: Resource.createApiCall
    method: "delete"
    path:   "{id}"
    requiredParams: ["id"]

  listSections: Resource.createApiCall
    method: "get"
    path:   "{id}/sections"
    requiredParams: ["id"]


module.exports = Schedules

