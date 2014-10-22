
React = require 'react'
R     = React.DOM

SectionSearchPane = React.createClass(

  render: ->
    R.div null,
      R.span null, "Search here"
      R.input placeholder: "Input"

)

module.exports = SectionSearchPane


