
React = require 'react'
R     = React.DOM


module.exports =

  componentWillMount: ->
    throw new Error "Must include IconMixin" if not @icon?

  handleItemDelete: (e)->
    e.preventDefault()
    e.stopPropagation()
    @props.handleItemDelete @props.item

  renderDeleteIcon: ->
    if @props.item.del is true
      @renderSpinner()
    else
      @icon "trash-o",
        fw: false
        className: "delete-icon"
        onClick: @handleItemDelete
