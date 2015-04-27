
React          = require 'react'
WeekCalendar   = React.createFactory require './WeekCalendar'
PlannerSideBar = React.createFactory require './PlannerSideBar'
R              = React.DOM


PlannerBody = React.createClass(

  render: ->
    R.section className: 'pla-planner-body container-fluid',
      PlannerSideBar ui: @props.ui
      WeekCalendar({})

)

module.exports = PlannerBody


