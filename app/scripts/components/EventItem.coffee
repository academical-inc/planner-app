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
IconMixin     = require '../mixins/IconMixin'
ItemMixin     = require '../mixins/ItemMixin'
AppActions    = require '../actions/AppActions'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

EventItem = React.createClass(

  mixins: [IconMixin, ItemMixin]

  handleColorSelect: (color)->
    AppActions.changeEventColor @props.item.id, color

  render: ->
    headingId      = "event-heading-#{@props.item.id}"
    colorPaletteId = "event-colors-#{@props.item.id}"
    colorStyle     = borderColor: @props.color

    R.div className: "pla-event-item pla-item panel panel-default",
      R.div
        className: "panel-heading"
        style: colorStyle
        role: "tab"
        id: headingId
        R.h4 className: "panel-title clearfix",
          R.a null, @props.item.name
        R.span className: "settings-container",
          @renderSettings()

)

module.exports = EventItem

