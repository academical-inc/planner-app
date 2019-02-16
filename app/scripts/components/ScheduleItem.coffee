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
ItemMixin     = require '../mixins/ItemMixin'
IconMixin     = require '../mixins/IconMixin'
AppActions    = require '../actions/AppActions'
R             = React.DOM

{ UiConstants,
  MAX_SCHEDULE_NAME_LENGTH } = require '../constants/PlannerConstants'


# TODO Test
ScheduleItem = React.createClass(

  mixins: [ItemMixin, IconMixin]

  getInitialState: ->
    editing: false

  inputVal: ->
    @refs.editInput.getDOMNode().value

  updateScheduleName: (name)->
    AppActions.updateScheduleName @props.item.id, name
    @setState editing: false

  handleEvent: (e)->
    e.preventDefault()
    e.stopPropagation()

  handleEdit: (e)->
    @handleEvent e
    @setState editing: true

  handleSaveEdit: (e)->
    @handleEvent e
    @updateScheduleName @inputVal()

  handleCancelEdit: (e)->
    @handleEvent e
    @setState editing: false

  handleKeyDown: (e)->
    switch e.keyCode
      when UiConstants.keys.ENTER
        @updateScheduleName @inputVal()
      when UiConstants.keys.ESC
        @setState editing: false

  render: ->
    schedule  = @props.item
    nameClass = if schedule.dirty then " dirty" else ""

    R.li className: "pla-schedule-item", onClick: @props.onClick,
      R.a className: "clearfix#{nameClass}", href: "#",
        if @state.editing
          R.input
            type: "text"
            placeholder: schedule.name
            autoFocus: true
            maxLength: MAX_SCHEDULE_NAME_LENGTH
            onKeyDown: @handleKeyDown
            onClick: @handleEvent
            ref: "editInput"
        else
          R.span className: "schedule-name", schedule.name
        R.span className: "pull-right",
          if @state.editing
            R.span className: 'edit-icons',
              @icon("times", onClick: @handleCancelEdit)
              @icon("check", onClick: @handleSaveEdit)
          else
            @icon "pencil", onClick: @handleEdit
          @renderDeleteIcon()

)

module.exports = ScheduleItem


