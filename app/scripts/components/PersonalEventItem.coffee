
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
    headingId      = "personal-event-heading-#{@props.item.id}"
    colorPaletteId = "personal-event-colors-#{@props.item.id}"
    colorStyle     =
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
            R.i className: "fa fa-trash-o delete-icon",\
              onClick: @props.handleItemDelete
          ColorPalette id: colorPaletteId
      )

)

module.exports = PersonalEventItem

