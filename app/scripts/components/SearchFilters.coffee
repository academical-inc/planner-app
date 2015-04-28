
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


SearchFilters = React.createClass(

  mixins: [I18nMixin]

  render: ->
    ui = @props.ui
    id = UiConstants.ids.SEARCH_FILTERS

    R.div className: "collapse pla-search-filters", id: id,
      "Here be the filters"

)

module.exports = SearchFilters
