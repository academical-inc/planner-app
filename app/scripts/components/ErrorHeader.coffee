
React        = require 'react'
LogoBox      = React.createFactory require './LogoBox'
R            = React.DOM


ErrorHeader = React.createClass(

  render: ->
    R.section className: 'pla-error-header hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default", role: "navigation",
        R.div className: "container-fluid",
          R.ul className: "nav navbar-nav",
            LogoBox({})

)

module.exports = ErrorHeader

