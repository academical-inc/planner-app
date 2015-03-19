
React         = require 'react'
IconMixin     = require '../mixins/IconMixin'
ItemMixin     = require '../mixins/ItemMixin'
{UiConstants} = require '../constants/PlannerConstants'
ColorPicker   = React.createFactory require './ColorPicker'
ColorPalette  = React.createFactory require './ColorPalette'
R             = React.DOM

EventItem = React.createClass(

  mixins: [IconMixin, ItemMixin]

  getInitialState: ->
    @props.item

  getColor: ->
    colors = UiConstants.colors
    @state.color || colors[Math.floor(Math.random() * colors.length)]

  render: ->
    headingId      = "event-heading-#{@props.item.id}"
    colorPaletteId = "event-colors-#{@props.item.id}"
    colorStyle     =
      borderColor: @getColor()

    R.div className: "pla-event-item panel panel-default",
      R.div(
        {
          className: "panel-heading"
          style: colorStyle
          role: "tab"
          id: headingId
        }
        R.h4 className: "panel-title clearfix",
          R.a null, @state.name
          R.span className: "pull-right",
            ColorPicker colorPaletteId: colorPaletteId
            @renderDeleteIcon()
          ColorPalette id: colorPaletteId
      )

)

module.exports = EventItem

