
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

