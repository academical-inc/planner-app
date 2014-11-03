
React       = require 'react'
SearchBar   = require './SearchBar.react'
SectionList = require './SectionList.react'
R           = React.DOM

PlannerSideBar = React.createClass(

  render: ->
    R.div className: 'pla-side-bar hidden-sm hidden-xs',
      SearchBar({})
      SectionList({})

)

module.exports = PlannerSideBar


