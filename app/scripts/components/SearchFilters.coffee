
$             = require 'jquery'
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
{UiConstants} = require '../constants/PlannerConstants'
AppActions    = require '../actions/AppActions'
R             = React.DOM


# TODO Tests
SearchFilters = React.createClass(

  mixins: [I18nMixin, IconMixin]

  handleFilterChecked: (e)->
    {target: {checked, name, value}} = e
    AppActions.toggleFilter checked, name, value

  handleSearch: (e)->
    $(@getDOMNode()).collapse 'toggle'
    @props.handleSearch() if @props.handleSearch?

  checkbox: (name, value)->
    R.div className: "checkbox", key: value,
      R.label null,
        R.input
          type: "checkbox"
          name: name
          value: value
          onChange: @handleFilterChecked
          value

  renderFilter: (f)->
    filterComp = switch f.type
      when "values"
        R.div className: 'form-group',
          R.label null, f.name
          f.values.map (v)=>
            @checkbox f.name, v
      when "boolean"
        R.div className: 'form-group',
          @checkbox f.name, f.name

    R.form null, filterComp

  renderRow: (key, f1, f2)->
    R.div className: "row", key: "filters-row-#{key}",
      R.div className: "col-md-6",
        @renderFilter f1
      R.div className: "col-md-6",
        @renderFilter f2 if f2?

  renderFilters: (filters)->
    for _, i in filters by 2
      f1 = filters[i]
      f2 = filters[i+1]
      @renderRow i, f1, f2

  render: ->
    filters = @props.filters
    id      = UiConstants.ids.SEARCH_FILTERS

    R.div className: "pla-search-filters collapse", id: id,
      @renderFilters filters
      R.div className: "row",
        R.button
          className: "btn btn-search btn-success btn-xs pull-right"
          type: "button"
          onClick: @handleSearch
          R.span null,
            @t "searchBar.applyFilters"
            @icon "filter"

)

module.exports = SearchFilters
