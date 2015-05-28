
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
          R.ul className: "nav navbar-nav navbar-left nav-logo-box",
            LogoBox({})
          R.ul className: "nav navbar-nav nav-menus",
            R.span className: "vertical-align-helper"
            OptionsMenu rootTag: R.li
            ScheduleList rootTag: R.li
          R.ul className: "nav navbar-nav",
            R.span className: "vertical-align-helper"
            R.li null,
              WeekControl({})
          R.ul className: "nav navbar-nav",
            R.span className: "vertical-align-helper"
            R.li null,
              ProfileBox name: "Juan", url: "//placehold.it/50x50"

)

module.exports = PlannerHeader

