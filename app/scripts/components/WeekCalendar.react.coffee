
React = require 'react'
R     = React.DOM

WeekCalendar = React.createClass(

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
    R.div className: 'week-calendar'

)

module.exports = WeekCalendar
