
React             = require 'react'
SearchBar         = require './SearchBar.react'
ScheduleInfoBar   = require './ScheduleInfoBar.react'
R                 = React.DOM

PlannerSideBar = React.createClass(

  render: ->
    R.div className: 'pla-side-bar hidden-sm hidden-xs',
      SearchBar({})
      ScheduleInfoBar({})

)

module.exports = PlannerSideBar

