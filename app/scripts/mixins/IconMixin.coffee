
React = require 'react/addons'
R     = React.DOM


iconClasses = (icon, {fw, inverse, classNames}={})->
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

spinnerClasses = ({type, anim, classNames}={})->
  type       ?= "spinner"
  anim       ?= "spin"
  classNames ?= []
  cs =
    fa: true
  cs["fa-#{type}"] = true
  cs["fa-#{anim}"] = true
  classNames.forEach (cls)-> cs[cls] = true
  React.addons.classSet cs


module.exports =

  iconMarkup: (icon, opts)->
    "<i class='#{iconClasses(icon, opts)}'>"

  icon: (icon, opts)->
    R.i className: iconClasses icon, opts

  spinnerMarkup: (opts)->
    "<i class='#{spinnerClasses(opts)}'>"

  renderSpinner: (opts)->
    R.i className: spinnerClasses opts

