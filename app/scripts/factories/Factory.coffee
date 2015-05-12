
_ = require '../utils/HelperUtils'

class Factory

  create: (obj)->
    _.objFilter obj, @_fields


module.exports = Factory
