
React          = require 'react'
WeekCalendar   = React.createFactory require './WeekCalendar'
PlannerHeader   = React.createFactory require './PlannerHeader'
R              = React.DOM


PlannerBody = React.createClass(

  render: ->
    R.section className: 'pla-planner-body',
      PlannerHeader({})
      WeekCalendar({})

)

module.exports = PlannerBody


