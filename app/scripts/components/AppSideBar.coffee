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

React           = require 'react'
SearchBar       = React.createFactory require './SearchBar'
ScheduleInfoBar = React.createFactory require './ScheduleInfoBar'
R               = React.DOM

AppSideBar = React.createClass(

  render: ->
    R.div className: 'pla-app-side-bar hidden-sm hidden-xs',
      SearchBar ui: @props.ui
      ScheduleInfoBar({})

)

module.exports = AppSideBar

