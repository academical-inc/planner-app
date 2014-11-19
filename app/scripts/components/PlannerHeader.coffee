
React        = require 'react'
ScheduleList = React.createFactory require './ScheduleList'
OptionsList  = React.createFactory require './OptionsList'
ProfileBox   = React.createFactory require './ProfileBox'
LogoBox      = React.createFactory require './LogoBox'
R            = React.DOM


PlannerHeader = React.createClass(

  render: ->
    R.div className: 'pla-planner-header hidden-xs hidden-sm',
      LogoBox({})
      ScheduleList({})
      OptionsList({})
      ProfileBox({})

)

module.exports = PlannerHeader

