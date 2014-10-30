
React          = require 'react'
WeekCalendar   = require './WeekCalendar.react'
PlannerSideBar = require './PlannerSideBar.react'
R              = React.DOM


PlannerBody = React.createClass(

  render: ->
    R.div className: 'pla-planner-body',
      PlannerSideBar({})
      WeekCalendar($: @props.$)

)

module.exports = PlannerBody


