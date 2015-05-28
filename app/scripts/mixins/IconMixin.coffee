
React      = require 'react'
Classnames = require 'classnames'
R          = React.DOM


iconClasses = (icon, {fw, inverse, className}={})->
  fw        ?= true
  inverse   ?= false
  className ?= ""
  cs =
    fa: true
    "fa-inverse": inverse
    "fa-fw": fw
  cs["fa-#{icon}"] = true
  className.split(" ").forEach (cls)-> cs[cls] = true
  Classnames cs

spinnerClasses = ({type, anim, className}={})->
  type      ?= "spinner"
  anim      ?= "spin"
  className ?= ""
  cs =
    fa: true
  cs["fa-#{type}"] = true
  cs["fa-#{anim}"] = true
  className.split(" ").forEach (cls)-> cs[cls] = true
  Classnames cs

imgIconClasses = (className="")->
  cs = {}
  cs["img-icon"] = true
  className.split(" ").forEach (cls)-> cs[cls] = true
  Classnames cs


module.exports =

  iconMarkup: (icon, opts)->
    "<i class='#{iconClasses(icon, opts)}'>"

  icon: (icon, opts={})->
    R.i
      className: iconClasses(icon, opts)
      onClick: opts.onClick
      style: opts.style
      ref: opts.ref

  imgIcon: (src, opts={})->
    img = R.img
      src: src
      className: imgIconClasses(opts.className)
      onClick: opts.onClick
      style: opts.style
      ref: opts.ref

    if opts.markup
      React.renderToStaticMarkup img
    else
      img


  spinnerMarkup: (opts)->
    "<i class='#{spinnerClasses(opts)}'>"

  renderSpinner: (opts={})->
    R.i
      className: spinnerClasses(opts)
      style: opts.style
      ref: opts.ref

