
React = require 'react'
R     = React.DOM


module.exports =

  handleItemDelete: (e)->
    e.stopPropagation()
    @props.handleItemDelete @props.item

  renderDeleteIcon: ->
    R.i className: "fa fa-trash-o delete-icon", onClick: @handleItemDelete

