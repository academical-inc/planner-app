
React = require 'react'
$     = require 'jquery'
R     = React.DOM

WeekCalendar = React.createClass(

  componentDidMount: ->
    $(@getDOMNode()).fullCalendar(
      defaultView: "agendaWeek"
      allDaySlot: false
      allDayText: false
      scrollTime: "07:00:00"
      firstDay: 1
      weekends: true
      editable: true
      selectable: true
      header:
        left: "prev"
        center: "today"
        right: "next"
    )

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
