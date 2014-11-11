
React          = require 'react'
WeekCalendar   = require './WeekCalendar'
PlannerSideBar = require './PlannerSideBar'
R              = React.DOM


PlannerBody = React.createClass(

  render: ->
    R.div className: 'pla-planner-body',
      PlannerSideBar({})
      WeekCalendar($: @props.$)

)

module.exports = PlannerBody


