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
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
StoreMixin    = require '../mixins/StoreMixin'
ScheduleStore = require '../stores/ScheduleStore'
UiStore       = require '../stores/UiStore'
# TODO Revisit this design. Must require even if not using
ExportStore   = require '../stores/ExportStore'
AppActions    = require '../actions/AppActions'
{UiConstants} = require '../constants/PlannerConstants'
Dropdown      = React.createFactory require './Dropdown'
OptionsItem   = React.createFactory require './OptionsItem'
R             = React.DOM


# TODO Test
OptionsMenu = React.createClass(

  mixins: [I18nMixin, IconMixin, StoreMixin(UiStore)]

  onChange: ->
    if UiStore.optionsMenu()
      @refs.dropdown.toggleDropdown()
    else
      @refs.dropdown.closeDropdown()

  getItems: ->
    [
      {
        id: "opt1"
        val: @t("options.summary")
        icon: @imgIcon "/images/resumen_icon.png"
      }
      {
        id: "opt2"
        val: @t("options.duplicate")
        icon: @imgIcon "/images/duplicate_icon.png"
      }
      {
        id: "opt3"
        val: @t("options.share")
        icon: @imgIcon "/images/share_icon.png"
      }
      {divider: true}
      {
        id: "opt4"
        val: @t("options.ics")
        icon: @imgIcon "/images/export_icon.png"
      }
      {
        id: "opt5"
        val: @t("options.image")
        icon: @imgIcon "/images/export_image_icon.png"
      }
    ]

  handleItemSelected: (item)->
    switch item.id
      when "opt1" then @openSummaryDialog()
      when "opt2" then @duplicateSchedule()
      when "opt3" then @openShareDialog()
      when "opt4" then @exportICS()
      when "opt5" then @exportImage()

  openSummaryDialog: ->
    AppActions.openSummaryDialog()

  duplicateSchedule: ->
    AppActions.duplicateSchedule()

  openShareDialog: ->
    # TODO Dispatching an action and creating a store seems like overkill for
    # this. Leaving like this for now
    $(UiConstants.selectors.SHARE_MODAL).modal 'show'

  exportICS: ->
    AppActions.exportToICS ScheduleStore.current().id

  exportImage: ->
    AppActions.exportToImage $(UiConstants.selectors.WEEK_CALENDAR)[0]

  render: ->
    Dropdown(
      className: 'pla-options-menu'
      ref: 'dropdown'
      rootTag: @props.rootTag
      title: @imgIcon "/images/sidebar_icon.png"
      itemType: OptionsItem
      items: @getItems()
      handleItemSelected: @handleItemSelected
    )

)

module.exports = OptionsMenu

