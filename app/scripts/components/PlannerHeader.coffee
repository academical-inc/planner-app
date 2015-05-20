
React        = require 'react'
ScheduleList = React.createFactory require './ScheduleList'
OptionsMenu  = React.createFactory require './OptionsMenu'
ProfileBox   = React.createFactory require './ProfileBox'
LogoBox      = React.createFactory require './LogoBox'
WeekControl  = React.createFactory require './WeekControl'
R            = React.DOM


PlannerHeader = React.createClass(

  render: ->
    R.section className: 'pla-planner-header hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default", role: "navigation",
        R.div className: "container-fluid",
          R.ul className: "nav navbar-nav navbar-left",
            LogoBox({})
          R.ul className: "nav navbar-nav navbar-dropdowns",
            OptionsMenu rootTag: R.li
            ScheduleList rootTag: R.li
          R.ul className: "nav navbar-nav",
            R.li null,
              WeekControl({})
          R.ul className: "nav navbar-nav",
            ProfileBox rootTag: R.li, name: "Juan", url: "//placehold.it/50x50"

)

module.exports = PlannerHeader

