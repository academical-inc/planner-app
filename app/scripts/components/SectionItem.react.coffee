
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
          R.li className: "list-group-item teachers", "Mr. Anderson"
          R.li className: "list-group-item", "Section 2, 3 credits"
      )
)

module.exports = SectionItem



