
React = require 'react'
R     = React.DOM

SearchBar = React.createClass(

  render: ->
    R.div className: "pla-search-bar container-fluid",
      R.div null,
        R.input type: "text", placeholder: "Search Courses..."
      R.div null,
        R.input type: "checkbox", "Advanced Search"

)

module.exports = SearchBar
