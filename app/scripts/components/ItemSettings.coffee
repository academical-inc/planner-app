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
I18nMixin    = require '../mixins/I18nMixin'
ColorPalette = React.createFactory require '../components/ColorPalette'
R            = React.DOM


ItemSettings = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: 'pla-item-settings',
      R.div null,
        ColorPalette
          item: @props.item
          handleColorSelect: @props.handleColorSelect
      R.div null,
        R.span null,
          @props.deleteIcon
          R.span
            className: "delete-msg"
            onClick: @props.handleItemDelete
            @t("sidebar.item.delete")

)

module.exports = ItemSettings
