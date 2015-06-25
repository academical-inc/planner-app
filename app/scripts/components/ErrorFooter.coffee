
React        = require 'react'
R            = React.DOM


ErrorFooter = React.createClass(

  render: ->
    R.section className: 'pla-error-footer hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default navbar-fixed-bottom",
          R.div className: "container-fluid"

)

module.exports = ErrorFooter
