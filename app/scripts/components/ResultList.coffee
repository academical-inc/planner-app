
React      = require 'react'
ResultItem = React.createFactory require './ResultItem'
R          = React.DOM


ResultList = React.createClass(

  handleResultMouseEnter: (idx)->
    @props.handleResultMouseEnter idx

  handleResultMouseLeave: (idx)->
    @props.handleResultMouseLeave idx

  handleResultClicked: (result, e)->
    e.preventDefault()
    @props.handleResultClicked result

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
        @renderItem(
          result
          i
          i is @props.focusedIndex
          i is @props.disabledIndex
        )

)

module.exports = ResultList
