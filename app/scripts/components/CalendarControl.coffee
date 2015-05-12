
React         = require 'react'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


CalendarControl = React.createClass(

  handlePrev: ->
    $(UiConstants.selectors.WEEK_CALENDAR).fullCalendar 'prev'

  handleToday: ->
    $(UiConstants.selectors.WEEK_CALENDAR).fullCalendar 'today'

  handleNext: ->
    $(UiConstants.selectors.WEEK_CALENDAR).fullCalendar 'next'

  render: ->
    R.div className: 'pla-calendar-control',
      R.button onClick: @handlePrev, '<'
      R.button onClick: @handleToday, 'Today'
      R.button onClick: @handleNext, '>'

)

module.exports = CalendarControl
