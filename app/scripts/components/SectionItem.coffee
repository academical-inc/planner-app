
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
ItemMixin     = require '../mixins/ItemMixin'
{UiConstants} = require '../constants/PlannerConstants'
ColorPalette  = React.createFactory require './ColorPalette'
R             = React.DOM


SectionItem = React.createClass(

  mixins: [I18nMixin, IconMixin, ItemMixin]

  getSeatsColorClass: ->
    seatsMap = UiConstants.sectionSeatsMap
    if @props.item.seats.available >= seatsMap.UPPER.bound
      seatsMap.UPPER.className
    else if @props.item.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      seatsMap.ZERO.className

  getColor: ->
    # TODO: Random color selection is temporary
    colors = UiConstants.colors
    @props.item.color || colors[Math.floor(Math.random() * colors.length)]

  handleColorSelect: (color)->
    console.log "selected", color

  render: ->
    headingId      = "section-heading-#{@props.item.id}"
    contentId      = "section-info-#{@props.item.id}"
    colorPaletteId = "section-colors-#{@props.item.id}"
    seatsClass     = @getSeatsColorClass()
    colorStyle     = borderColor: @getColor()
    teacherNames   = if @props.item.teacherNames.length == 0
      @t("sidebar.section.noTeacher")
    else
      @props.item.teacherNames.join ", "

    R.div className: "pla-section-item pla-item panel panel-default",
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
            "#{@props.item.courseCode} - #{@props.item.courseName}"
          )
          R.span className: "pull-right",
            R.span className: "label label-seats label-#{seatsClass}",
              @props.item.seats.available
            @renderSettings()
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
            @t("sidebar.section.seats", seats: @props.item.seats.available)
          R.li className: "list-group-item teachers",
            teacherNames
          R.li className: "list-group-item",
            @t("sidebar.section.info", credits: @props.item.credits,\
              number: @props.item.sectionNumber, id: @props.item.sectionId)
          R.li className: "list-group-item clearfix",
            R.span null, "#{@props.item.departments[0].name}"
      )
)

module.exports = SectionItem
