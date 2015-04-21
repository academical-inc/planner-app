
React          = require 'react'
IconMixin      = require '../mixins/IconMixin'
ItemMixin      = require '../mixins/ItemMixin'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
R              = React.DOM

EventItem = React.createClass(

  mixins: [IconMixin, ItemMixin]

  handleColorSelect: (color)->
    PlannerActions.changeEventColor @props.item.id, color

  render: ->
    headingId      = "event-heading-#{@props.item.id}"
    colorPaletteId = "event-colors-#{@props.item.id}"
    colorStyle     = borderColor: @props.color

    R.div className: "pla-event-item pla-item panel panel-default",
      R.div(
        {
          className: "panel-heading"
          style: colorStyle
          role: "tab"
          id: headingId
        }
        R.h4 className: "panel-title clearfix",
          R.a null, @props.item.name
          R.span className: "pull-right",
            @renderSettings()
      )

)

module.exports = EventItem

