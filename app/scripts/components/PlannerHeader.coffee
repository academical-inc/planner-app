
React        = require 'react'
ScheduleList = React.createFactory require './ScheduleList'
ProfileBox   = React.createFactory require './ProfileBox'
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

