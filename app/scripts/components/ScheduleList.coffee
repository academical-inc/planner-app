
React = require 'react'
$     = require 'jquery'
mq    = require '../utils/MediaQueries.coffee'
R     = React.DOM

ScheduleList = React.createClass(

  componentDidMount: ->
    if not mq.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  getInitialState: ->
    data: ["Schedule1", "Schedule2"]

  render: ->
    R.div className: 'pla-schedule-list',
      R.ul null,
        (R.li(key: sch, sch) for sch in @state.data)

)

module.exports = ScheduleList

