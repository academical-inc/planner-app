
React        = require 'react'
colors       = require('../constants/PlannerConstants').colors
ColorPicker  = React.createFactory require './ColorPicker'
ColorPalette = React.createFactory require './ColorPalette'
R            = React.DOM

SectionItem = React.createClass(

  render: ->
    headingId      = "section-heading-#{@props.key}"
    contentId      = "section-info-#{@props.key}"
    colorPaletteId = "section-colors-#{@props.key}"
    style          =
      borderColor: colors[Math.floor(Math.random() * colors.length)]

    R.div className: "pla-section-item panel panel-default",
      R.div(
        {
          className: "panel-heading"
          style: style
          role: "tab"
          id: headingId
        }
        R.h4(className: "panel-title clearfix",
          R.a(
            {
              className: "collapsed"
              href: "##{contentId}"
              "data-toggle": "collapse"
              "aria-expanded": "false"
              "aria-controls": contentId
            },
            @props.item.name
          )
          R.span className: "pull-right",
            R.span className: "label label-seats label-success", "20"
            R.i className: "fa fa-trash-o delete"
        )
      ),
      R.div(
        {
          className: "panel-collapse collapse"
          style: style
          role: "tabpanel"
          id: contentId
          "aria-labelledby": headingId
        },
        R.ul className: "list-group",
          R.li className: "list-group-item list-group-item-success seats",
            "20 seats available"
          R.li className: "list-group-item teachers", "Dimitri Alejo, Juan Tejada"
          R.li className: "list-group-item",
            R.span null, "3 credits - "
            R.span null, "Section 2 - "
            R.span null, "45578"
          R.li className: "list-group-item clearfix",
            R.span null, "Math Department"
            ColorPicker colorPaletteId: colorPaletteId
            ColorPalette id: colorPaletteId
      )
)

module.exports = SectionItem



