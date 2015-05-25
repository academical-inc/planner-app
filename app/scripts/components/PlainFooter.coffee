
React        = require 'react'
R            = React.DOM


PlainHeader = React.createClass(

  render: ->
    R.section className: 'pla-plain-footer hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default navbar-fixed-bottom",
          R.div className: "container-fluid"

)

module.exports = PlainHeader

