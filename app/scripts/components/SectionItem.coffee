
React        = require 'react'
constants    = require '../constants/PlannerConstants'
colors       = constants.colors
seatsMap     = constants.sectionSeatsMap
ColorPicker  = React.createFactory require './ColorPicker'
ColorPalette = React.createFactory require './ColorPalette'
R            = React.DOM


SectionItem = React.createClass(

  getInitialState: ->
    @props.item

  getSeatsColorClass: ->
    if @state.seats.available >= seatsMap.UPPER.bound
      seatsMap.UPPER.className
    else if @state.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      seatsMap.ZERO.className

  getColor: ->
    # TODO: Random color selection is temporary
    @state.color || colors[Math.floor(Math.random() * colors.length)]

  render: ->
    headingId      = "section-heading-#{@props.itemKey}"
    contentId      = "section-info-#{@props.itemKey}"
    colorPaletteId = "section-colors-#{@props.itemKey}"
    seatsClass     = @getSeatsColorClass()
    colorStyle     =
      borderColor: @getColor()

    R.div className: "pla-section-item panel panel-default",
      R.div(
        {
          className: "panel-heading"
          style: colorStyle
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
            "#{@state.courseCode} - #{@state.courseName}"
          )
          R.span className: "pull-right",
            R.span className: "label label-seats label-#{seatsClass}",
              @state.seats.available
            R.i className: "fa fa-trash-o delete",\
              onClick: @props.handleItemDelete
        )
      ),
      R.div(
        {
          className: "panel-collapse collapse"
          style: colorStyle
          role: "tabpanel"
          id: contentId
          "aria-labelledby": headingId
        },
        R.ul className: "list-group",
          R.li className: "list-group-item list-group-item-#{seatsClass} seats",
            "#{@state.seats.available} seats available"
          R.li className: "list-group-item teachers",
            @state.teacherNames.join ", "
          R.li className: "list-group-item",
            R.span null, "#{@state.credits} credits - "
            R.span null, "Section #{@state.sectionNumber} - "
            R.span null, "#{@state.sectionId}"
          R.li className: "list-group-item clearfix",
            R.span null, "#{@state.departments[0].name}"
            ColorPicker colorPaletteId: colorPaletteId
            ColorPalette id: colorPaletteId
      )
)

module.exports = SectionItem



