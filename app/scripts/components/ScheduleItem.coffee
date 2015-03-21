
React     = require 'react'
ItemMixin = require '../mixins/ItemMixin'
IconMixin = require '../mixins/IconMixin'
R         = React.DOM


ScheduleItem = React.createClass(

  mixins: [ItemMixin, IconMixin]

  render: ->
    nameClass = if @props.item.dirty then " dirty" else ""
    R.li className: "pla-schedule-item", onClick: @props.onClick,
      R.a className: "clearfix#{nameClass}", href: "#", @props.item.name,
        R.span className: "pull-right", @renderDeleteIcon()

)

module.exports = ScheduleItem


