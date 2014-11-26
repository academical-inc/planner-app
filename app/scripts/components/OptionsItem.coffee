
React = require 'react'
R     = React.DOM


OptionsItem = React.createClass(

  render: ->
    item = @props.item
    R.li className: "pla-options-item", onClick: @props.onClick,
      R.a href: "#", item.icon, " #{item.val}"

)

module.exports = OptionsItem

