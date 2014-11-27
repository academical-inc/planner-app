
React = require 'react'
R     = React.DOM


module.exports =

  icon: (icon, className)->
    R.i className: "fa fa-#{icon} fa-fw"

