
React = require 'react'
R     = React.DOM

PlannerSideBar = React.createClass(

  render: ->
    R.div className: 'pla-side-bar hidden-sm hidden-xs',
      R.span null, "Search here"
      R.input placeholder: "Input"

)

module.exports = PlannerSideBar


