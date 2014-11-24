
React     = require 'react'
I18nMixin = require '../mixins/I18nMixin'
R         = React.DOM

SearchBar = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: "pla-search-bar container-fluid",
      R.div className: "search-input",
        R.input type: "text", placeholder: @t("searchBar.placeholder")
      R.div className: "search-filters",
        R.a(
          {
            className: "filters-toggle collapsed"
            href: "#filters-body"
            "data-toggle": "collapse"
            "aria-expanded": "false"
            "aria-controls": "filters-body"
          },
          @t "searchBar.filters"
        )
        R.div className: "collapse", id: "filters-body",
          "Here be the filters"

)

module.exports = SearchBar
