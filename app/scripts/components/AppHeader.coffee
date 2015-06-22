
React        = require 'react'
ScheduleList = React.createFactory require './ScheduleList'
OptionsMenu  = React.createFactory require './OptionsMenu'
ProfileBox   = React.createFactory require './ProfileBox'
LogoBox      = React.createFactory require './LogoBox'
WeekControl  = React.createFactory require './WeekControl'
R            = React.DOM


AppHeader = React.createClass(

  render: ->
    R.section className: 'pla-app-header hidden-xs hidden-sm',
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
            WeekControl({})
          R.ul className: "nav navbar-nav",
            R.span className: "vertical-align-helper"
            ProfileBox {}

)

module.exports = AppHeader

