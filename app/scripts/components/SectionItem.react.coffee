
React       = require 'react'
R           = React.DOM
colors      = require('../constants/PlannerConstants').colors

SectionItem = React.createClass(

  render: ->
    headingId = "section-heading-#{@props.key}"
    contentId = "section-info-#{@props.key}"
    style =
      borderColor: colors[Math.floor(Math.random() * colors.length)]

    R.div className: "panel panel-default",
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
            @props.section.name
          )
          R.span className: "pull-right",
            R.span className: "label label-seats label-success", "20"
            R.i className: "fa fa-trash-o"
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
            R.a
              className: "color-picker pull-right collapsed"
              href: "#colors"
              "data-toggle": "collapse"
              "data-target": "#colors"
              "aria-expanded": "false"
              "aria-controls": "colors"
            R.div className: "collapse", id: "colors",
              (R.div(
                className: "color"
                style: {backgroundColor: color}
               ) for color in colors)
      )
)

module.exports = SectionItem



