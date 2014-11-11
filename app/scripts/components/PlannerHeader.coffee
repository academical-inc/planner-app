
React        = require 'react'
ScheduleList = require './ScheduleList'
ProfileBox   = require './ProfileBox'
R            = React.DOM


PlannerHeader = React.createClass(

  render: ->
    R.div className: 'pla-planner-header hidden-xs hidden-sm',
      R.div className: 'pla-logo',
        R.span null, "Logo Here"
      ScheduleList($: @props.$)
      ProfileBox({})

)

module.exports = PlannerHeader

