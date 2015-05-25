
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
SearchStore    = require '../stores/SearchStore'
PreviewStore   = require '../stores/PreviewStore'
{UiConstants}  = require '../constants/PlannerConstants'
{PreviewTypes} = require '../constants/PlannerConstants'
PlannerActions = require '../actions/PlannerActions'
ResultItem     = React.createFactory require './ResultItem'
SearchFilters  = React.createFactory require './SearchFilters'
Autosuggest    = React.createFactory require 'react-autosuggest'
R              = React.DOM

# Private
_lastInputVal   = ''
_selectedParent = null
_input          = null
_isOverlapping  = false


# TODO Tests
SearchBar = React.createClass(

  mixins: [I18nMixin, IconMixin]

  getInitialState: ->
    corequisites: false
    searching: false
    filtersCollapsed: true
    iconPos:
      top: ".45em"
      left: "12em"

  showSuggestionsWhen: (input)->
    input.trim().length > UiConstants.search.MIN_LEN

  suggestions: (input, cb)->
    @setState searching: true
    SearchStore.search input, (suggestions)=>
      @setState searching: false
      cb null, suggestions[...UiConstants.search.MAX_RESULTS]

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
    _isOverlapping = PreviewStore.isOverlapping()

  handleSectionSelect: (section)->
    if section.corequisites.length > 0
      input = @input()
      _lastInputVal = input.val()
      _selectedParent = section
      if not _isOverlapping
        PlannerActions.addPreview section, PreviewTypes.PRIMARY
        @setState corequisites: true, =>
          @refs.autosuggest.setSuggestionsState section.corequisites
    else
      @addSection section, PreviewTypes.PRIMARY
      @refs.autosuggest.setState value: null

  handleCorequisiteSelect: (section)->
    @addSection _selectedParent, PreviewTypes.PRIMARY
    @addSection section, PreviewTypes.SECONDARY
    @setState corequisites: false, =>
      @refs.autosuggest.setState value: null

  handleSelect: (section)->
    if @state.corequisites
      @handleCorequisiteSelect section
    else
      @handleSectionSelect section

  curPreviewType: ->
    if @state.corequisites
      PreviewTypes.SECONDARY
    else
      PreviewTypes.PRIMARY

  # TODO Do not close autosuggest if can't add section
  addSection: (section, previewType)->
    PlannerActions.removePreview previewType
    if not _isOverlapping
      _isOverlapping = false
      PlannerActions.addSection section, UiConstants.DEFAULT_SECTION_COLOR

  clearCorequisites: ->
    @setState corequisites: false, =>
      @refs.autosuggest.onInputChange target: value: _lastInputVal

  input: ->
    _input ?= $(React.findDOMNode(@refs.autosuggest.refs.input))
    _input

  setSearchIconPos: ->
    input  = @input()
    pos    = input.position()
    inputW = input.outerWidth true
    iconW  = @refs.searchIcon.getDOMNode().offsetWidth
    @setState iconPos:
      top: pos.top + 2
      left: pos.left + inputW

  initFiltersCollapse: ->
    filters = $(@refs.filters.getDOMNode())
    filters.on 'show.bs.collapse', =>
      @setState filtersCollapsed: false
    filters.on 'hide.bs.collapse', =>
      @setState filtersCollapsed: true

  componentDidMount: ->
    @setSearchIconPos()
    @initFiltersCollapse()

  render: ->
    coreqs          = @state.corequisites

    filtersSelector = UiConstants.selectors.SEARCH_FILTERS
    filtersId       = UiConstants.ids.SEARCH_FILTERS
    filtersTrgClass = "search-filters-trigger"
    filtersTrgClass += " collapsed" if @state.filtersCollapsed

    iconProps  =
      className: "search-icon"
      style: @state.iconPos
      ref: "searchIcon"
    searchIcon = if @state.searching
      @renderSpinner iconProps
    else
      @icon "search", iconProps

    R.div
      className: "pla-search-bar container-fluid"
      Autosuggest
        ref: "autosuggest"
        inputAttributes:
          className: "search-input"
          placeholder: @t "searchBar.placeholder"
        showWhen: @showSuggestionsWhen
        suggestions: @suggestions
        suggestionValue: @suggestionValue
        suggestionRenderer: @suggestionRenderer
        onSuggestionFocused: @handleSectionFocus
        onSuggestionUnfocused: @handleSectionUnfocus
        onSuggestionSelected: @handleSelect
      searchIcon
      if coreqs
        R.div className: 'corequisites',
          @t "searchBar.corequisites"
          R.button className: "close",
            R.img src: '/images/popup_quit_icon.png',
            onClick: @clearCorequisites
      R.div className: filtersTrgClass,
        R.a
          className: "filters-toggle collapsed"
          href: filtersSelector
          "data-toggle": "collapse"
          "aria-expanded": "false"
          "aria-controls": filtersId
          @t "searchBar.filters"
      R.div null,
        SearchFilters filters: @props.ui.searchFilters, ref: "filters"

)

module.exports = SearchBar
