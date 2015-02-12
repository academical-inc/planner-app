
React         = require 'react'
$             = require 'jquery'
{UiConstants} = require '../constants/PlannerConstants'
MediaQueries  = require '../utils/MediaQueries.coffee'
I18nMixin     = require '../mixins/I18nMixin'
ScheduleStore = require '../stores/ScheduleStore'
Dropdown      = React.createFactory require './Dropdown'
ScheduleItem  = React.createFactory require './ScheduleItem'
R             = React.DOM


ScheduleList = React.createClass(

  mixins: [I18nMixin]

  _getState: ->
    current = ScheduleStore.getCurrent()

    openSchedule: if current? then current.name else "..."
    schedules: ScheduleStore.getAll().map (sch)->
      id: sch.id, val: sch.name

  _onChange: ->
    console.log "changed!"
    @setState @_getState()

  componentDidMount: ->
    ScheduleStore.addChangeListener @_onChange
    if not MediaQueries.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  getInitialState: ->
    @_getState()

  render: ->
    Dropdown(
      id: UiConstants.ids.SCHEDULE_LIST
      className: 'pla-schedule-list'
      rootTag: @props.rootTag
      title: @state.openSchedule
      items: @state.schedules
      itemType: ScheduleItem
      handleItemAdd: ->
      addItemPlaceholder: @t "scheduleList.namePlaceholder"
    )

)

module.exports = ScheduleList

