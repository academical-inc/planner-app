
React = require 'react'
R     = React.DOM

SearchBar = React.createClass(

  render: ->
    R.div className: "pla-search-bar container-fluid",
      R.div className: "search-input",
        R.input type: "text", placeholder: "Search Courses..."
      R.div className: "search-filters",
        R.a(
          {
            className: "filters-toggle collapsed"
            href: "#filters-body"
            "data-toggle": "collapse"
            "data-target": "#filters-body"
            "aria-expanded": "false"
            "aria-controls": "filters-body"
          },
          "Filters"
        )
        R.div className: "collapse", id: "filters-body",
          "Here be the filters"

)

module.exports = SearchBar
