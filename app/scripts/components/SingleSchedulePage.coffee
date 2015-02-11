
React = require 'react'
R     = React.DOM


SingleSchedulePage = React.createClass(

  render: ->
    R.div null, "Single Schedule #{@props.scheduleId}!!"

)

module.exports = SingleSchedulePage
