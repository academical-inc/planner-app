
_ = require '../utils/HelperUtils'

class Factory

  # TODO Test
  create: (obj, {exclude}={})->
    exclude ?= []
    fields   = if exclude.length > 0
      if Array.isArray @_fields
        @_fields.filter (f)-> not (f in exclude)
      else
        _.objInclude @_fields, Object.keys(@_fields).filter (f)->
          not (f in exclude)
    else
      @_fields

    _.objInclude obj, fields


module.exports = Factory
