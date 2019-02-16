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

React         = require 'react'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


ColorPalette = React.createClass(

  renderColor: (color)->
    handleColorSelect = @props.handleColorSelect
    R.div
      key: color
      className: "color"
      style: {backgroundColor: color}
      "data-color": color
      onClick: handleColorSelect.bind null, color if handleColorSelect?

  render: ->
    count = UiConstants.COLORS.length
    R.div className: "pla-color-palette",
      R.div className: "color-row",
        (@renderColor color for color in UiConstants.COLORS[0...count/2])
      R.div className: "color-row",
        (@renderColor color for color in UiConstants.COLORS[count/2...count])

)

module.exports = ColorPalette
