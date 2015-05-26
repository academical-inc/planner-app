
React           = require 'react'
WeekCalendar    = React.createFactory require './WeekCalendar'
R               = React.DOM

SingleSchedulePage = React.createClass(

  render: ->
    R.div className: "pla-schedule-container",
      WeekCalendar({})

)

module.exports = SingleSchedulePage
