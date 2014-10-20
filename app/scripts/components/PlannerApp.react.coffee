
React = require 'react'
R     = React.DOM

PlannerApp = React.createClass(

  componentDidMount: ->
    $(@getDOMNode()).fullCalendar(
      defaultView: "agendaWeek"
      allDaySlot: false
      allDayText: false
      header:
        left: 'prev'
        center: 'today'
        right: 'next'
    )

  render: ->
    R.div className: 'calendar'

)

module.exports = PlannerApp
