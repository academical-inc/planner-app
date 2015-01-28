
React             = require 'react'
$                 = require 'jquery'
MediaQueries      = require '../utils/MediaQueries.coffee'
UIConstants       = require('../constants/PlannerConstants').ui
I18nMixin         = require '../mixins/I18nMixin'
ScheduleListStore = require '../stores/ScheduleListStore'
Dropdown          = React.createFactory require './Dropdown'
ScheduleItem      = React.createFactory require './ScheduleItem'
R                 = React.DOM


ScheduleList = React.createClass(

  mixins: [I18nMixin]

  componentDidMount: ->
    ScheduleListStore.addChangeListener @onChange
    if not MediaQueries.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  getInitialState: ->
    data: [{id: "S1", val: "Schedule 1"}, {id: "S2", val: "Schedule 2"}]

  render: ->
    Dropdown(
      id: UIConstants.ids.SCHEDULE_LIST
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

