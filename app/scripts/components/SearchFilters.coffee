
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


SearchFilters = React.createClass(

  mixins: [I18nMixin]

  checkbox: (name, value)->
    R.div className: "checkbox", key: value,
      R.label null,
        R.input type: "checkbox", value: value, name

  renderFilter: (f)->
    R.form null,
      if f.values is true
        R.div className: 'form-group',
          @checkbox f.name, f.name
      else
        R.div className: 'form-group',
          R.label null, f.name
          f.values.map (v)=>
            @checkbox v, v

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

)

module.exports = SearchFilters
