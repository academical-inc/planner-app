
React        = require 'react'
ColorPicker  = require './ColorPicker.react'
ColorPalette = require './ColorPalette.react'
colors       = require('../constants/PlannerConstants').colors
R            = React.DOM

PersonalEventItem = React.createClass(

  render: ->
    headingId = "personal-event-heading-#{@props.key}"
    colorPaletteId  = "personal-event-colors-#{@props.key}"
    style =
      borderColor: colors[Math.floor(Math.random() * colors.length)]

    R.div className: "pla-personal-event-item panel panel-default",
      R.div(
        {
          className: "panel-heading"
          style: style
          role: "tab"
          id: headingId
        }
        R.h4 className: "panel-title clearfix",
          R.a null, @props.item.name
          R.span className: "pull-right",
            ColorPicker colorPaletteId: colorPaletteId
            R.i className: "fa fa-trash-o delete"
          ColorPalette id: colorPaletteId
      )

)

module.exports = PersonalEventItem




