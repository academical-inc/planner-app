
React       = require 'react'
R           = React.DOM

SectionItem = React.createClass(

  render: ->
    R.div className: "panel panel-default",
      R.div(
        {className: "panel-heading", role: "tab", id: "heading-#{@props.key}"},
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
          role: "tabpanel"
          id: "collapse-#{@props.key}"
          "aria-labelledby": "heading-#{@props.key}"
        },
        R.div className: "panel-body", "Section Info"
      )
)

module.exports = SectionItem



