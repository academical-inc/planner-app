
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
SearchStore   = require '../stores/SearchStore'
{UiConstants} = require '../constants/PlannerConstants'
ResultItem    = React.createFactory require './ResultItem'
Typeahead     = React.createFactory require 'react-autosuggest'
R             = React.DOM


SearchBar = React.createClass(

  mixins: [I18nMixin]

  showSuggestionsWhen: (input)->
    input.trim().length > UiConstants.search.minLen

  suggestions: (input, cb)->
    SearchStore.query input, (suggestions)->
      cb null, suggestions

  suggestionValue: (section)->
    section.courseName

  suggestionRenderer: (section, query)->
    ResultItem
      section: section
      query: query

  render: ->
    R.div className: "pla-search-bar container-fluid",
      R.div className: "search-input",
        Typeahead
          inputAttributes:
            className: "typeahead"
            placeholder: @t("searchBar.placeholder")
          showWhen: @showSuggestionsWhen
          suggestions: @suggestions
          suggestionValue: @suggestionValue
          suggestionRenderer: @suggestionRenderer
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
