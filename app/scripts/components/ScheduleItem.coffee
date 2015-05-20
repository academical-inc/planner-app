
React          = require 'react'
ItemMixin      = require '../mixins/ItemMixin'
IconMixin      = require '../mixins/IconMixin'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
R              = React.DOM


# TODO Tests
ScheduleItem = React.createClass(

  mixins: [ItemMixin, IconMixin]

  getInitialState: ->
    editing: false

  inputVal: ->
    @refs.editInput.getDOMNode().value

  updateScheduleName: (name)->
    PlannerActions.updateScheduleName @props.item.id, name
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
            onKeyDown: @handleKeyDown
            onClick: @handleEvent
            ref: "editInput"
        else
          schedule.name
        R.span className: "pull-right",
          if @state.editing
            R.span null,
              @icon("check", onClick: @handleSaveEdit)
              @icon("times", onClick: @handleCancelEdit)
          else
            @icon "pencil", onClick: @handleEdit
          @renderDeleteIcon()

)

module.exports = ScheduleItem


