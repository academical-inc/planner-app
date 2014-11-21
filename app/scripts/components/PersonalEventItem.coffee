
React        = require 'react'
colors       = require('../constants/PlannerConstants').colors
ColorPicker  = React.createFactory require './ColorPicker'
ColorPalette = React.createFactory require './ColorPalette'
R            = React.DOM

PersonalEventItem = React.createClass(

  getInitialState: ->
    @props.item

  getColor: ->
    @state.color || colors[Math.floor(Math.random() * colors.length)]

  render: ->
    headingId = "personal-event-heading-#{@props.itemKey}"
    colorPaletteId  = "personal-event-colors-#{@props.itemKey}"
    colorStyle =
      borderColor: @getColor()

    R.div className: "pla-personal-event-item panel panel-default",
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
            R.i className: "fa fa-trash-o delete"
          ColorPalette id: colorPaletteId
      )

)

module.exports = PersonalEventItem

