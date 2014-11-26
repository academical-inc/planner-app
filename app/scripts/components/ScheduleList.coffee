
React        = require 'react'
$            = require 'jquery'
mq           = require '../utils/MediaQueries.coffee'
Dropdown     = React.createFactory require './Dropdown'
ScheduleItem = React.createFactory require './ScheduleItem'
R            = React.DOM


ScheduleList = React.createClass(

  componentDidMount: ->
    if not mq.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  getInitialState: ->
    data: [{id: "S1", val: "Schedule 1"}, {id: "S2", val: "Schedule 2"}]

  render: ->
    Dropdown(
      className: 'pla-schedule-list'
      rootTag: @props.rootTag
      title: @state.data[0].val
      items: @state.data
      itemType: ScheduleItem
      updateNameOnSelect: true
      handleItemAdd: ->
    )

)

module.exports = ScheduleList

