
React       = require 'react'
R           = React.DOM
colors      = require('../constants/PlannerConstants').colors

SectionItem = React.createClass(

  render: ->
    style =
      borderColor: colors[Math.floor(Math.random() * colors.length)]

    R.div className: "panel panel-default",
      R.div(
        {
          className: "panel-heading"
          style: style
          role: "tab"
          id: "heading-#{@props.key}"
        },
        R.h4(className: "panel-title",
          R.a(
            {
              className: "collapsed"
              href: "#collapse-#{@props.key}"
              "data-toggle": "collapse"
              "data-parent": "##{@props.parent}"
              "aria-expanded": "false"
              "aria-controls": "collapse-#{@props.key}"
            },
            @props.key
          )
        )
      ),
      R.div(
        {
          className: "panel-collapse collapse"
          style: style
          role: "tabpanel"
          id: "collapse-#{@props.key}"
          "aria-labelledby": "heading-#{@props.key}"
        },
        R.div className: "panel-body", "Section Info"
      )
)

module.exports = SectionItem



