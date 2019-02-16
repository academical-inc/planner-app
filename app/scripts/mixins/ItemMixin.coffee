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

$            = require 'jquery'
React        = require 'react'
Popover      = React.createFactory require '../components/Popover'
ItemSettings = React.createFactory require '../components/ItemSettings'
R            = React.DOM


module.exports =

  componentWillMount: ->
    throw new Error "Must include IconMixin" if not @icon?

  handleItemDelete: (e)->
    e.preventDefault()
    e.stopPropagation()
    @props.handleItemDelete @props.item

  renderDeleteIcon: ->
    if @props.item.del is true
      @renderSpinner()
    else
      @imgIcon "/images/delete_icon.png",
        onClick: @handleItemDelete
        className: "delete-icon"

  renderSettingsIcon: ->
    if @props.item.del is true
      @renderSpinner()
    else
      @imgIcon '/images/settings_icon.png',

  renderSettings: ->
    Popover
      content: ItemSettings
        handleColorSelect: @handleColorSelect
        handleItemDelete: @handleItemDelete
        deleteIcon: @renderDeleteIcon()
      placement: 'bottom'
      trigger: 'click'
      R.span className: 'settings-icon',
        @renderSettingsIcon()
