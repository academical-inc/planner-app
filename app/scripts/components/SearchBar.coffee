
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
SearchStore    = require '../stores/SearchStore'
{UiConstants}  = require '../constants/PlannerConstants'
{PreviewTypes} = require '../constants/PlannerConstants'
PlannerActions = require '../actions/PlannerActions'
ResultItem     = React.createFactory require './ResultItem'
Autosuggest    = React.createFactory require 'react-autosuggest'
R              = React.DOM

# Private
_lastInputVal    = ''
_selectedSection = null


SearchBar = React.createClass(

  mixins: [I18nMixin, IconMixin]

  getInitialState: ->
    corequisites: false
    searching: false

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

  handleSectionUnfocus: (section)->
    PlannerActions.removePreview @curPreviewType()

  handleSectionFocus: (section)->
    PlannerActions.addPreview section, @curPreviewType()

  handleSectionSelect: (section)->
    if @state.corequisites
      @handleCorequisiteSelect section
    else
      @handleInitialSelect section

  handleInitialSelect: (section)->
    if section.corequisites.length > 0
      input = $(@refs.autosuggestWrapper.getDOMNode()).find('input')
      _lastInputVal = input.val()
      _selectedSection = section
      PlannerActions.addPreview section, PreviewTypes.PRIMARY
      @setState corequisites: true, =>
        @refs.autosuggest.setSuggestionsState section.corequisites
    else
      @addSection section, PreviewTypes.PRIMARY

  handleCorequisiteSelect: (section)->
    @addSection _selectedSection, PreviewTypes.PRIMARY
    @addSection section, PreviewTypes.SECONDARY
    @setState corequisites: false

  curPreviewType: ->
    if @state.corequisites
      PreviewTypes.SECONDARY
    else
      PreviewTypes.PRIMARY

  addSection: (section, previewType)->
    PlannerActions.removePreview previewType
    PlannerActions.addSection section, UiConstants.defaultSectionColor

  clearCorequisites: ->
    @setState corequisites: false, =>
      @refs.autosuggest.onInputChange target: value: _lastInputVal

  render: ->
    R.div className: "pla-search-bar container-fluid",
      R.div className: "autosuggest-wrapper", ref: "autosuggestWrapper",
        Autosuggest
          ref: "autosuggest"
          inputAttributes:
            className: "autosuggest"
            placeholder: @t "searchBar.placeholder"
          showWhen: @showSuggestionsWhen
          suggestions: @suggestions
          suggestionValue: @suggestionValue
          suggestionRenderer: @suggestionRenderer
          onSuggestionFocused: @handleSectionFocus
          onSuggestionUnfocused: @handleSectionUnfocus
          onSuggestionSelected: @handleSectionSelect
        if @state.corequisites
          R.div className: 'corequisites',
            @t "searchBar.corequisites"
            @icon "times", onClick: @clearCorequisites
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
