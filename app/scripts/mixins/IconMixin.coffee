#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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

