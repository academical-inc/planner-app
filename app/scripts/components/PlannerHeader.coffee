
React        = require 'react'
ScheduleList = React.createFactory require './ScheduleList'
OptionsList  = React.createFactory require './OptionsList'
ProfileBox   = React.createFactory require './ProfileBox'
LogoBox      = React.createFactory require './LogoBox'
R            = React.DOM


PlannerHeader = React.createClass(

  render: ->
    R.section className: 'pla-planner-header hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default", role: "navigation",
        R.div className: "container-fluid",
          LogoBox({})
          R.ul className: "nav navbar-nav navbar-left",
            ScheduleList rootTag: R.li
          R.ul className: "nav navbar-nav navbar-right",
            OptionsList rootTag: R.li

      # ProfileBox({})

)

module.exports = PlannerHeader

