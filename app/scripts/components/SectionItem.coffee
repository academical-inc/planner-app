
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
ItemMixin      = require '../mixins/ItemMixin'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
ColorPalette   = React.createFactory require './ColorPalette'
R              = React.DOM


SectionItem = React.createClass(

  mixins: [I18nMixin, IconMixin, ItemMixin]

  getSeatsColorClass: ->
    seatsMap = UiConstants.sectionSeatsMap
    section  = @props.item
    if section.seats.available >= seatsMap.UPPER.bound
      seatsMap.UPPER.className
    else if section.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      seatsMap.ZERO.className

  handleColorSelect: (color)->
    PlannerActions.changeSectionColor section.id, color

  componentDidMount: ->
    $(@refs.seatsIndicator.getDOMNode()).tooltip
      placement: "top"
      title: @t "section.seatsTT"

  render: ->
    section        = @props.item
    headingId      = "section-heading-#{section.id}"
    contentId      = "section-info-#{section.id}"
    colorPaletteId = "section-colors-#{section.id}"
    seatsClass     = @getSeatsColorClass()
    colorStyle     = borderColor: @props.color
    teacherNames   = if section.teacherNames.length > 0
      section.teacherNames.join ", "
    else
      @t "section.noTeacher"
    department = if section.departments.length > 0
      section.departments[0].name
    else
      @t "section.noDepartment"

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
            "#{section.courseCode} - #{section.courseName}"
          )
          R.span className: "pull-right",
            R.span
              className: "label label-seats label-#{seatsClass}"
              ref: "seatsIndicator"
              section.seats.available
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
            @t("section.seats", seats: section.seats.available)
          R.li className: "list-group-item teachers",
            teacherNames
          R.li className: "list-group-item",
            @t("section.info", credits: section.credits,\
              number: section.sectionNumber, id: section.sectionId)
          R.li className: "list-group-item clearfix",
            R.span null, department
      )
)

module.exports = SectionItem
