
React = require 'react'
R     = React.DOM


LogoBox = React.createClass(

  render: ->
    R.div className: 'pla-logo-box',
      R.span className: "vertical-align-helper"
      R.img src: '/images/academical_logo.png'

)

module.exports = LogoBox
