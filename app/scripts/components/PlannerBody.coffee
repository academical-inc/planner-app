
React          = require 'react'
WeekCalendar   = React.createFactory require './WeekCalendar'
PlannerSideBar = React.createFactory require './PlannerSideBar'
R              = React.DOM


PlannerBody = React.createClass(

  render: ->
    R.div className: 'pla-planner-body',
      PlannerSideBar({})
      WeekCalendar($: @props.$)

)

module.exports = PlannerBody


