Backbone = require 'backbone'
$        = require 'jquery'
Config   = require './config'


backboneSync = Backbone.sync
Backbone.sync = (method, model, options)->
  url = if $.isFunction model.url then model.url() else model.url
  url = "#{Config.urls.API_URI}/#{url}"

  options = $.extend {}, options, {url: url, data: {camelize: true}}
  backboneSync method, model, options


