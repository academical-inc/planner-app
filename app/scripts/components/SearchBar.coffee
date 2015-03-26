
React                = require 'react'
Bloodhound           = require 'bloodhound'
Env                  = require '../Env'
I18nMixin            = require '../mixins/I18nMixin'
TypeaheadSectionItem = require './TypeaheadSectionItem'
R                    = React.DOM


SearchBar = React.createClass(

  mixins: [I18nMixin]

  datumTokenizer:(section)->
    teacherNames = section.teacherNames.map (name)->
      Bloodhound.tokenizers.whitespace name

    if teacherNames.length > 0
      teacherNames = teacherNames.reduce (a1, a2) -> a1.concat(a2)

    [].concat(
      Bloodhound.tokenizers.whitespace section.courseName
      [section.courseCode]
      Bloodhound.tokenizers.whitespace section.departments[0].name
      [section.sectionId]
      teacherNames
    )

  dupDetector: (section1, section2)->
    section1.sectionId == section2.sectionId

  initSearchEngine: ->
    engine = new Bloodhound
      name: 'sections',
      prefetch:
        url: Env.SECTIONS_URL
        ttl: 1
      limit: 30
      datumTokenizer: @datumTokenizer
      dupDetector:    @dupDetector
      queryTokenizer: Bloodhound.tokenizers.whitespace

    engine.initialize()
    engine.ttAdapter()

  componentDidMount: ->
    engine = @initSearchEngine()
    $(@refs.search.getDOMNode()).typeahead(
      {hint: true, highlight: true, minLength: 1}
      {
        source: engine
        displayKey: "courseName"
        templates:
          suggestion: TypeaheadSectionItem.render
      }
    )

  render: ->
    R.div className: "pla-search-bar container-fluid",
      R.div className: "search-input",
        R.input
          className: "typeahead"
          ref: "search"
          type: "text"
          placeholder: @t("searchBar.placeholder")
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
