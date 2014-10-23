
React = require 'react'
R     = React.DOM

ProfileBox = React.createClass(

  render: ->
    R.div className: 'pla-profile-box',
      R.span null, "Someone's name"

)

module.exports = ProfileBox

