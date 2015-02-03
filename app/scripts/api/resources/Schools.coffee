
Resource = require '../Resource'


class Schools extends Resource

  path: "schools"

  retrieve: @createApiCall
    method: "get"
    path: "{id}"
    requiredParams: ["id"]



module.exports = Schools
