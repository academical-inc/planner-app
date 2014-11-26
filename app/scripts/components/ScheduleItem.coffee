
React     = require 'react'
ItemMixin = require '../mixins/ItemMixin'
R         = React.DOM


ScheduleItem = React.createClass(

  mixins: [ItemMixin]

  render: ->
    R.li className: "pla-schedule-item", onClick: @props.onClick,
      R.a href: "#", @props.item.val,
        R.span className: "pull-right",
          @renderDeleteIcon()

)

module.exports = ScheduleItem


