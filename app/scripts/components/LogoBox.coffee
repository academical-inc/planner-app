
React = require 'react'
R     = React.DOM


LogoBox = React.createClass(

  render: ->
    R.div className: 'pla-logo-box navbar-header',
      R.a className: "navbar-brand", href: "#",
        R.img src: 'images/academical_logo.png'

)


module.exports = LogoBox
