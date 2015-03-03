
React = require 'react/addons'
R     = React.DOM


classes = (icon, {fw, inverse, classNames}={})->
  fw         ?= true
  inverse    ?= false
  classNames ?= []
  cs =
    fa: true
    "fa-inverse": inverse
    "fa-fw": fw
  cs["fa-#{icon}"] = true
  classNames.forEach (cls)-> cs[cls] = true
  React.addons.classSet cs

module.exports =

  iconMarkup: (icon, opts)->
    "<i class='#{classes(icon, opts)}'>"

  icon: (icon, opts)->
    R.i className: classes icon, opts

