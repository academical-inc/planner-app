
React = require 'react'
R     = React.DOM

ProfileBox = React.createClass(

  render: ->
    R.div null,
      R.span null, "Someone's name"

)

module.exports = ProfileBox

