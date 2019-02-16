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

React = require 'react'
I18nMixin = require '../mixins/I18nMixin'
R     = React.DOM

PanelItemList = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: "pla-panel-item-list #{@props.className}",
      R.h4 className: "list-header", @props.header
      R.h5 className: "list-subheader", @props.subheader if @props.subheader?
      R.div
        className: "panel-group"
        role: "tablist"
        "aria-multiselectable": "true"
        for item in @props.items
          @props.itemType
            key: item.id
            item: item
            color: item.color or @props.colors[item.id]
            handleItemDelete: @props.handleItemDelete
      if @props.handleItemAdd?
        R.div className: "add-item-bar",
          R.button
            type: "button"
            className: "btn btn-circle"
            onClick: @props.handleItemAdd
            R.img src: '/images/add_event_icon.png'
          R.span
            className: "add-item-header"
            onClick: @props.handleItemAdd
            @t("sidebar.createEvent")

)

module.exports = PanelItemList

