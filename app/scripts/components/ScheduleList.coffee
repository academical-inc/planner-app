
React    = require 'react'
Dropdown = React.createFactory require './Dropdown'
R        = React.DOM

ScheduleList = React.createClass(

  render: ->
    R.div className: 'pla-schedule-list',
      Dropdown({})

)

module.exports = ScheduleList

