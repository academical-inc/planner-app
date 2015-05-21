
React            = require 'react'
PlannerConstants = require '../constants/PlannerConstants'
R                = React.DOM

selectors = PlannerConstants.UiConstants.selectors
commands  = PlannerConstants.WeekCalendarCommands

WeekControl = React.createClass(

  handlePrev: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.PREV

  handleToday: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.TODAY

  handleNext: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.NEXT

  render: ->
    R.div className: 'pla-calendar-control',
      R.button
        onClick: @handlePrev
        R.img src: '/images/previous_arrow.png'
      R.button onClick: @handleToday, 'Today'
      R.button
        onClick: @handleNext
        R.img src: '/images/next_arrow.png'

)

module.exports = WeekControl
