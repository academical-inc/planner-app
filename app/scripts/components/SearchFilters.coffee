
React     = require 'react'
I18nMixin = require '../mixins/I18nMixin'
R         = React.DOM


SearchFilters = React.createClass(

  mixins: [I18nMixin]

  render: ->
    ui = @props.ui

    R.div className: "pla-search-filters",
      R.a
        className: "filters-toggle collapsed"
        href: "#filters-body"
        "data-toggle": "collapse"
        "aria-expanded": "false"
        "aria-controls": "filters-body"
        @t "searchBar.filters"
      R.div className: "collapse", id: "filters-body",
        "Here be the filters"

)

module.exports = SearchFilters
