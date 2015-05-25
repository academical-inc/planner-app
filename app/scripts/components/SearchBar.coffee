
React                = require 'react'
I18nMixin            = require '../mixins/I18nMixin'
IconMixin            = require '../mixins/IconMixin'
StoreMixin           = require '../mixins/StoreMixin'
SearchStore          = require '../stores/SearchStore'
PreviewStore         = require '../stores/PreviewStore'
{UiConstants}        = require '../constants/PlannerConstants'
{PreviewTypes}       = require '../constants/PlannerConstants'
PlannerActions       = require '../actions/PlannerActions'
ResultList           = React.createFactory require './ResultList'
SearchFilters        = React.createFactory require './SearchFilters'
SearchFiltersTrigger = React.createFactory require './SearchFiltersTrigger'
R                    = React.DOM


# Private
_selectedParent = null
_lastResults = []
_lastFocused = null

# TODO Tests
SearchBar = React.createClass(

  mixins: [I18nMixin, IconMixin, StoreMixin(SearchStore)]

  getState: ->
    corequisites: false
    filtersCollapsed: true
    focusedIndex: null
    disabledIndex: null
    inputVal: SearchStore.query()
    searching: SearchStore.searching()
    results: SearchStore.results()[...UiConstants.search.MAX_RESULTS]

  getInitialState: ->
    @getState()

  onChange: ->
    @setState @getState()

  initFiltersCollapse: ->
    filters = $(@refs.filters.getDOMNode())
    filters.on 'show.bs.collapse', =>
      @setState filtersCollapsed: false
    filters.on 'hide.bs.collapse', =>
      @setState filtersCollapsed: true

  componentDidMount: ->
    @initFiltersCollapse()

  search: ->
    val = @refs.input.getDOMNode().value
    if val.length >= UiConstants.search.MIN_LEN
      PlannerActions.search val
    else
      @setState results: [], focusedIndex: null

  previewType: ->
    if @state.corequisites
      PreviewTypes.SECONDARY
    else
      PreviewTypes.PRIMARY

  addPreview: (section, previewType=@previewType())->
    PlannerActions.addPreview section, previewType

  removePreview: (previewType=@previewType())->
    PlannerActions.removePreview previewType

  addSection: (section)->
    PlannerActions.addSection section, UiConstants.DEFAULT_SECTION_COLOR

  focusResult: (idx)->
    section = @state.results[idx]
    @setState
      focusedIndex: idx
      inputVal: section.courseName
    @addPreview section
    @setState disabledIndex: if PreviewStore.isOverlapping() then idx else null

  unfocusResult: ->
    @setState focusedIndex: null, inputVal: SearchStore.query()
    @removePreview()

  clearCorequisites: ->
    @setState
      corequisites: false
      results: _lastResults
      inputVal: SearchStore.query()
      focusedIndex: _lastFocused

  selectCorequisite: (coreq)->
    @removePreview PreviewTypes.PRIMARY
    @removePreview PreviewTypes.SECONDARY
    @addSection _selectedParent
    @addSection coreq
    @setState corequisites: false, =>
      @refs.input.getDOMNode().blur()

  selectSection: (section)->
    if section.corequisites.length > 0
      _selectedParent = section
      _lastResults = @state.results.concat []
      _lastFocused = @state.focusedIndex
      @setState
        corequisites: true
        results: section.corequisites
        focusedIndex: null
        =>
          @refs.input.getDOMNode().focus()
    else
      @removePreview()
      @addSection section
      @refs.input.getDOMNode().blur()

  selectResult: (section)->
    section ?= @state.results[@state.focusedIndex]
    if not PreviewStore.isOverlapping()
      if @state.corequisites
        @selectCorequisite section
      else
        @selectSection section

  handleEnterPressed: ->
    if @state.focusedIndex?
      @selectResult()
    else
      @setState inputVal: ""

  handleEscPressed: ->
    if @state.corequisites
      @clearCorequisites()
    else
      if @state.results.length is 0
        @setState inputVal: ""
      else
        @setState results: []

  handleUpDownPressed: (up)->
    down = not up
    len  = @state.results.length
    idx  = @state.focusedIndex
    if len is 0
      @search()
    else
      if idx?
        if (idx is 0 and up) or (idx is len-1 and down)
          @unfocusResult()
        else
          @focusResult if up then (idx - 1) else (idx + 1)
      else
        @focusResult if up then (len - 1) else 0

  handleInputKeyDown: (e)->
    switch e.keyCode
      when UiConstants.keys.ENTER then @handleEnterPressed()
      when UiConstants.keys.ESC then @handleEscPressed()
      when UiConstants.keys.UP then @handleUpDownPressed true
      when UiConstants.keys.DOWN then @handleUpDownPressed false

  handleInputBlur: ->
    @unfocusResult()
    if @state.corequisites
      # @clearCorequisites()
    else
      # @setState results: [], inputVal: ''

  handleInputChange: (e)->
    @setState inputVal: e.target.value
    @search()

  renderCoreqsMessage: ->
    R.div className: 'corequisites-message',
      @t "searchBar.corequisites"
      R.button className: "close",
        R.img src: '/images/popup_quit_icon.png',
        onClick: @clearCorequisites

  renderSearchIcon: ->
    iconProps  =
      className: "search-icon"
    if @state.searching
      @renderSpinner iconProps
    else
      @icon "search", iconProps

  render: ->
    coreqs = @state.corequisites

    R.div className: "pla-search-bar container-fluid",
      R.div className: 'search-input',
        R.input
          type: "text"
          ref: "input"
          placeholder: @t "searchBar.placeholder"
          value: @state.inputVal
          onKeyDown: @handleInputKeyDown
          onBlur: @handleInputBlur
          onChange: @handleInputChange
        @renderSearchIcon()
      if @state.results.length > 0
        ResultList
          query: @state.inputVal
          results: @state.results
          focusedIndex: @state.focusedIndex
          disabledIndex: @state.disabledIndex
          handleResultMouseEnter: @focusResult
          handleResultMouseLeave: @unfocusResult
          handleResultClicked: @selectResult
      SearchFiltersTrigger
        collapsed: @state.filtersCollapsed
        filtersSelector: UiConstants.selectors.SEARCH_FILTERS
        filtersId: UiConstants.ids.SEARCH_FILTERS
      R.div null,
        SearchFilters filters: @props.ui.searchFilters, ref: "filters"
      @renderCoreqsMessage() if coreqs

)

module.exports = SearchBar
