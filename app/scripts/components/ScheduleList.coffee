
React        = require 'react'
$            = require 'jquery'
mq           = require '../utils/MediaQueries.coffee'
ids          = require('../constants/PlannerConstants').ids
I18nMixin    = require '../mixins/I18nMixin'
Dropdown     = React.createFactory require './Dropdown'
ScheduleItem = React.createFactory require './ScheduleItem'
R            = React.DOM


ScheduleList = React.createClass(

  mixins: [I18nMixin]

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
      id: ids.SCHEDULE_LIST
      className: 'pla-schedule-list'
      rootTag: @props.rootTag
      title: @state.data[0].val
      items: @state.data
      itemType: ScheduleItem
      updateNameOnSelect: true
      handleItemAdd: ->
      addItemPlaceholder: @t "scheduleList.namePlaceholder"
    )

)

module.exports = ScheduleList

