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

$             = require 'jquery'
React         = require 'react'
Classnames    = require 'classnames'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

SlideMenuHandle = React.createClass(

  handleClick: (e)->
    $(UiConstants.selectors.SCHEDULE_LIST).data("mmenu").open()

  render: ->
    classes = Classnames({
      'fa'
      'fa-th-list'
      'fa-2x'
    })
    R.div
      className: 'pla-slide-menu-handle hidden-md hidden-lg',
      onClick: @handleClick
      R.i className: classes

)

module.exports = SlideMenuHandle
