
Resource = require '../Resource'


class Schools extends Resource

  path: "schools"

  retrieve: Resource.createApiCall
    method: "get"
    path: "{id}"
    requiredParams: ["id"]


module.exports = Schools
