
React         = require 'react'
IconMixin     = require '../mixins/IconMixin'
ItemMixin     = require '../mixins/ItemMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

EventItem = React.createClass(

  mixins: [IconMixin, ItemMixin]

  getInitialState: ->
    @props.item

  getColor: ->
    colors = UiConstants.colors
    @props.item.color || colors[Math.floor(Math.random() * colors.length)]

  handleColorSelect: (color)->
    console.log "selected", color

  render: ->
    headingId      = "event-heading-#{@props.item.id}"
    colorPaletteId = "event-colors-#{@props.item.id}"
    colorStyle     =
      borderColor: @getColor()

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

