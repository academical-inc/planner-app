
React = require 'react'
R     = React.DOM


ScheduleItem = React.createClass(

  render: ->
    R.li className: "pla-schedule-item", onClick: @props.onClick,
      R.a href: "#", @props.item.val,
        R.span className: "pull-right",
          R.i className: "fa fa-trash-o delete-icon",\
            onClick: @props.handleItemDelete

)

module.exports = ScheduleItem


