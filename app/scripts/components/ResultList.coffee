
React      = require 'react'
I18nMixin  = require '../mixins/I18nMixin'
ResultItem = React.createFactory require './ResultItem'
R          = React.DOM


# TODO Test
ResultList = React.createClass(

  mixins: [I18nMixin]

  handleResultMouseEnter: (idx)->
    @props.handleResultMouseEnter idx

  handleResultMouseLeave: (idx)->
    @props.handleResultMouseLeave idx

  handleResultClicked: (result, e)->
    e.preventDefault()
    @props.handleResultClicked result

  renderNullItem: (idx)->
    R.li
      key: "no-result-#{idx}"
      className: 'no-result'
      R.span null, @t("searchBar.noResults")

  renderItem: (result, idx, focused, disabled)->
    className = "result"
    className += " result-focused" if focused
    className += " result-disabled" if disabled
    R.li
      key: "result-#{idx}"
      className: className,
      onMouseEnter: @handleResultMouseEnter.bind @, idx
      onMouseLeave: @handleResultMouseLeave.bind @, idx
      onMouseDown: @handleResultClicked.bind @, result
      ResultItem
        section: result
        query: @props.query
        focused: focused

  render: ->
    R.ul className: 'pla-result-list',
      @props.results.map (result, i)=>
        if result?
          @renderItem(
            result
            i
            i is @props.focusedIndex
            i is @props.disabledIndex
          )
        else
          @renderNullItem i

)

module.exports = ResultList
