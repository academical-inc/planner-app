
Backbone = require 'backbone'


class BaseModel extends Backbone.Model

  parse: (resp, xhr)->
    resp.data

  toJSON: ->
    {data: _.clone(@attributes)}


module.exports = BaseModel
