
React = require 'react'
R     = React.DOM


ScheduleItem = React.createClass(

  handleItemDelete: (e)->
    e.stopPropagation()
    @props.handleItemDelete @props.item

  render: ->
    R.li className: "pla-schedule-item", onClick: @props.onClick,
      R.a href: "#", @props.item.val,
        R.span className: "pull-right",
          R.i className: "fa fa-trash-o delete-icon",\
            onClick: @handleItemDelete

)

module.exports = ScheduleItem


