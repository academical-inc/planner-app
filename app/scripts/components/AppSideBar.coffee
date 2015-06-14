
React           = require 'react'
SearchBar       = React.createFactory require './SearchBar'
ScheduleInfoBar = React.createFactory require './ScheduleInfoBar'
R               = React.DOM

AppSideBar = React.createClass(

  render: ->
    R.div className: 'pla-app-side-bar hidden-sm hidden-xs',
      SearchBar ui: @props.ui
      ScheduleInfoBar({})

)

module.exports = AppSideBar

