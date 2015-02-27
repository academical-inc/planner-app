
React        = require 'react'
ItemMixin    = require '../mixins/ItemMixin'
SpinnerMixin = require '../mixins/SpinnerMixin'
R            = React.DOM


ScheduleItem = React.createClass(

  mixins: [ItemMixin, SpinnerMixin]

  render: ->
    nameClass = if @props.item.dirty then " dirty" else ""
    R.li className: "pla-schedule-item", onClick: @props.onClick,
      R.a className: "clearfix#{nameClass}", href: "#", @props.item.name,
        R.span className: "pull-right",
          if @props.item.del is true
            @renderSpinner()
          else
            @renderDeleteIcon()

)

module.exports = ScheduleItem


