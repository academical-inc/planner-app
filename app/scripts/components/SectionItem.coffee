
React        = require 'react'
_            = require '../utils/Utils'
I18nMixin    = require '../mixins/I18nMixin'
IconMixin    = require '../mixins/IconMixin'
ItemMixin    = require '../mixins/ItemMixin'
SectionUtils = require '../utils/SectionUtils'
SchoolStore  = require '../stores/SchoolStore'
AppActions   = require '../actions/AppActions'
ColorPalette = React.createFactory require './ColorPalette'
R            = React.DOM


SectionItem = React.createClass(

  mixins: [I18nMixin, IconMixin, ItemMixin]

  fieldFor: SectionUtils.fieldFor

  handleColorSelect: (color)->
    section  = @props.item
    AppActions.changeSectionColor section.id, color

  componentDidMount: ->
    school = SchoolStore.school().nickname
    $(@refs.seatsIndicator.getDOMNode()).tooltip
      placement: "top"
      title: @t "section.seatsTT.#{school}"

  render: ->
    school         = SchoolStore.school().nickname
    section        = @props.item
    headingId      = "section-heading-#{section.id}"
    contentId      = "section-info-#{section.id}"
    colorPaletteId = "section-colors-#{section.id}"
    seatsClass     = SectionUtils.seatsColorClass section
    colorStyle     = borderColor: @props.color
    teacherNames   = SectionUtils.teacherNames(section)
    department     = SectionUtils.department(section)

    R.div className: "pla-section-item pla-item panel panel-default",
      R.div
        className: "panel-heading"
        style: colorStyle
        role: "tab"
        id: headingId
        R.h4 className: "panel-title clearfix",
          R.a
            className: "collapsed"
            href: "##{contentId}"
            "data-toggle": "collapse"
            "aria-expanded": "false"
            "aria-controls": contentId
            R.span null, "#{section.courseCode} - "
            R.strong title: section.courseName, section.courseName
        R.span className: "settings-container",
          R.span
            className: "label-seats label-seats-#{seatsClass}"
            ref: "seatsIndicator"
            _.getNested section, @fieldFor("seats")
          @renderSettings()
      R.div
        className: "panel-collapse collapse"
        style: colorStyle
        role: "tabpanel"
        id: contentId
        "aria-labelledby": headingId
        R.ul className: "list-group",
          R.li className: "list-group-item list-group-item-#{seatsClass} seats",
            @t(
              "section.seats.#{school}"
              seats: _.getNested(section,@fieldFor("seats"))
            )
          R.li className: "list-group-item teachers",
            teacherNames
          R.li className: "list-group-item",
            @t("section.info.#{school}", credits: section.credits,\
              number: section.sectionNumber, id: section.sectionId)
          R.li className: "list-group-item clearfix",
            R.span null, department

)

module.exports = SectionItem
