
React        = require 'react'
WeekCalendar = React.createFactory require './WeekCalendar'
AppSideBar   = React.createFactory require './AppSideBar'
R            = React.DOM


AppBody = React.createClass(

  render: ->
    R.section className: 'pla-app-body container-fluid',
      AppSideBar ui: @props.ui
      WeekCalendar({})

)

module.exports = AppBody


