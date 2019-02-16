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
$             = require 'jquery'
MediaQueries  = require '../utils/MediaQueries.coffee'
IconMixin     = require '../mixins/IconMixin'
I18nMixin     = require '../mixins/I18nMixin'
StoreMixin    = require '../mixins/StoreMixin'
ScheduleStore = require '../stores/ScheduleStore'
UiStore       = require '../stores/UiStore'
AppActions    = require '../actions/AppActions'
Dropdown      = React.createFactory require './Dropdown'
ScheduleItem  = React.createFactory require './ScheduleItem'
R             = React.DOM

{ UiConstants,
  MAX_SCHEDULES,
  MAX_SCHEDULE_NAME_LENGTH } = require '../constants/PlannerConstants'


ScheduleList = React.createClass(

  mixins: [IconMixin, I18nMixin, StoreMixin(
    {store: ScheduleStore, handler: 'onChange'}
    {store: UiStore, handler: 'onUiChange'}
  )]

  getState: ->
    current = ScheduleStore.current()
    current: if current? then current.name else @renderSpinner()
    schedules: ScheduleStore.all()

  onUiChange: ->
    if UiStore.scheduleList()
      @refs.dropdown.toggleDropdown()
    else
      @refs.dropdown.closeDropdown()

  onChange: (state=@getState())->
    @setState state

  addSchedule: (name)->
    AppActions.createSchedule name

  openSchedule: (scheduleItem)->
    schedule =
      id: scheduleItem.id
      name: scheduleItem.val
    AppActions.openSchedule schedule

  deleteSchedule: (scheduleItem)->
    AppActions.deleteSchedule scheduleItem.id if scheduleItem.id?

  getInitialState: ->
    @getState()

  componentDidMount: ->
    if not MediaQueries.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        navbar:
          add: false
        dragOpen:
          open: true
      )
    return

  renderDropdown: ->
    Dropdown(
      id: UiConstants.ids.SCHEDULE_LIST
      ref: 'dropdown'
      className: 'pla-schedule-list'
      rootTag: @props.rootTag
      title: @state.current
      items: @state.schedules
      itemType: ScheduleItem
      addItemPlaceholder: @t "scheduleList.namePlaceholder"
      closeOnAdd: false
      maxInputLength: MAX_SCHEDULE_NAME_LENGTH
      maxItems: MAX_SCHEDULES
      handleItemAdd: @addSchedule
      handleItemSelected: @openSchedule
      handleItemDelete: @deleteSchedule
    )

  renderList: ->
    R.div id: UiConstants.ids.SCHEDULE_LIST,
      R.ul null,
        @state.schedules.map (sch, i)=>
          R.li
            key: "sch-#{i}"
            onClick: =>
              @openSchedule id: sch.id, val: sch.name
              $(@getDOMNode()).data("mmenu").close()
            R.a href: UiConstants.selectors.SCHEDULE_LIST, sch.name

  render: ->
    if not MediaQueries.matchesMDAndUp()
      @renderList()
    else
      @renderDropdown()

)

module.exports = ScheduleList

