#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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

