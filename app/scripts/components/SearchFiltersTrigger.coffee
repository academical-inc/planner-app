
React     = require 'react'
I18nMixin = require '../mixins/I18nMixin'
R         = React.DOM


SearchFiltersTrigger = React.createClass(

  mixins: [I18nMixin]

  render: ->
    className = 'pla-search-filters-trigger'
    className += " collapsed" if @props.collapsed
    className += " filtering" if @props.filtering

    title = if @props.filtering
      @t "searchBar.filtering"
    else
      @t "searchBar.filters"

    R.div className: className,
      R.a
        className: "filters-toggle collapsed"
        href: @props.filtersSelector
        "data-toggle": "collapse"
        "aria-expanded": "false"
        "aria-controls": @props.filtersId
        title

)

module.exports = SearchFiltersTrigger
