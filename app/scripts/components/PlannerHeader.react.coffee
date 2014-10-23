
React        = require 'react'
ScheduleList = require './ScheduleList.react'
ProfileBox   = require './ProfileBox.react'
R            = React.DOM


PlannerHeader = React.createClass(

  render: ->
    R.div className: 'pla-planner-header hidden-xs hidden-sm',
      R.div className: 'pla-logo',
        R.span null, "Logo Here"
      ScheduleList({})
      ProfileBox({})

)

module.exports = PlannerHeader

