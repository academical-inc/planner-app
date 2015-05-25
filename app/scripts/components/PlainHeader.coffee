
React        = require 'react'
LogoBox      = React.createFactory require './LogoBox'
R            = React.DOM


PlainHeader = React.createClass(

  render: ->
    R.section className: 'pla-plain-header hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default", role: "navigation",
        R.div className: "container-fluid",
          R.ul className: "nav navbar-nav navbar-left",
            LogoBox({})

)

module.exports = PlainHeader

