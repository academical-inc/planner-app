
React = require 'react'
R     = React.DOM

ScheduleList = React.createClass(

  render: ->
    R.ul null,
      R.li null, "Schedule 1"
      R.li null, "Schedule 2"

)

module.exports = ScheduleList

