
React    = require 'react'
$        = require 'jquery'
mq       = require '../utils/MediaQueries.coffee'
Dropdown = React.createFactory require './Dropdown'
R        = React.DOM


ScheduleList = React.createClass(

  componentDidMount: ->
    if not mq.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  getInitialState: ->
    data: [{key: "S1", val: "Schedule 1"}, {key: "S2", val: "Schedule 2"}]

  render: ->
    Dropdown(
      className: 'pla-schedule-list'
      rootTag: @props.rootTag
      title: @state.data[0].val
      items: @state.data
      updateNameOnSelect: true
    )
    # R.div className: 'pla-schedule-list',
    #   R.ul null,
    #     (R.li(key: sch, sch) for sch in @state.data)

)

module.exports = ScheduleList

