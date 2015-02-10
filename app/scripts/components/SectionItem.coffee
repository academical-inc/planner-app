
React        = require 'react'
I18nMixin    = require '../mixins/I18nMixin'
ItemMixin    = require '../mixins/ItemMixin'
UIConstants  = require('../constants/PlannerConstants').Ui
ColorPicker  = React.createFactory require './ColorPicker'
ColorPalette = React.createFactory require './ColorPalette'
R            = React.DOM


SectionItem = React.createClass(

  mixins: [I18nMixin, ItemMixin]

  getInitialState: ->
    @props.item

  getSeatsColorClass: ->
    seatsMap = UIConstants.sectionSeatsMap
    if @state.seats.available >= seatsMap.UPPER.bound
      seatsMap.UPPER.className
    else if @state.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      seatsMap.ZERO.className

  getColor: ->
    # TODO: Random color selection is temporary
    colors = UIConstants.colors
    @state.color || colors[Math.floor(Math.random() * colors.length)]

  render: ->
    headingId      = "section-heading-#{@props.item.id}"
    contentId      = "section-info-#{@props.item.id}"
    colorPaletteId = "section-colors-#{@props.item.id}"
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
            @renderDeleteIcon()
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
            @t("sidebar.section.seats", seats: @state.seats.available)
          R.li className: "list-group-item teachers",
            @state.teacherNames.join ", "
          R.li className: "list-group-item",
            @t("sidebar.section.info", credits: @state.credits,\
              number: @state.sectionNumber, id: @state.sectionId)
          R.li className: "list-group-item clearfix",
            R.span null, "#{@state.departments[0].name}"
            ColorPicker colorPaletteId: colorPaletteId
            ColorPalette id: colorPaletteId
      )
)

module.exports = SectionItem



