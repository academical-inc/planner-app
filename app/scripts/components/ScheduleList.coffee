
React         = require 'react'
$             = require 'jquery'
MediaQueries  = require '../utils/MediaQueries.coffee'
IconMixin     = require '../mixins/IconMixin'
I18nMixin     = require '../mixins/I18nMixin'
ScheduleStore = require '../stores/ScheduleStore'
AppActions    = require '../actions/AppActions'
Dropdown      = React.createFactory require './Dropdown'
ScheduleItem  = React.createFactory require './ScheduleItem'
R             = React.DOM

{ UiConstants,
  MAX_SCHEDULES,
  MAX_SCHEDULE_NAME_LENGTH } = require '../constants/PlannerConstants'


ScheduleList = React.createClass(

  mixins: [IconMixin, I18nMixin]

  getState: ->
    current = ScheduleStore.current()
    current: if current? then current.name else @renderSpinner()
    schedules: ScheduleStore.all()

  onChange: (state=@getState())->
    @setState state

  addSchedule: (name)->
    AppActions.createSchedule name

  openSchedule: (scheduleItem)->
    schedule =
      id: scheduleItem.id
      name: scheduleItem.val
    AppActions.openSchedule schedule

  deleteSchedule: (scheduleItem)->
    AppActions.deleteSchedule scheduleItem.id if scheduleItem.id?

  getInitialState: ->
    @getState()

  componentDidMount: ->
    ScheduleStore.addChangeListener @onChange
    if not MediaQueries.matchesMDAndUp()
      $(@getDOMNode()).mmenu(
        dragOpen:
          open: true
      )
    return

  componentWillUnmount: ->
    ScheduleStore.removeChangeListener @onChange

  render: ->
    Dropdown(
      id: UiConstants.ids.SCHEDULE_LIST
      className: 'pla-schedule-list'
      rootTag: @props.rootTag
      title: @state.current
      items: @state.schedules
      itemType: ScheduleItem
      addItemPlaceholder: @t "scheduleList.namePlaceholder"
      closeOnAdd: false
      maxInputLength: MAX_SCHEDULE_NAME_LENGTH
      maxItems: MAX_SCHEDULES
      handleItemAdd: @addSchedule
      handleItemSelected: @openSchedule
      handleItemDelete: @deleteSchedule
    )

)

module.exports = ScheduleList

