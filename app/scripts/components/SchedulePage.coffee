
React         = require 'react'
StoreMixin    = require '../mixins/StoreMixin'
ScheduleStore = require '../stores/ScheduleStore'
AppActions    = require '../actions/AppActions'
LoadingView   = React.createFactory require './LoadingView'
WeekCalendar  = React.createFactory require './WeekCalendar'
R             = React.DOM


SchedulePage = React.createClass(

  mixins: [StoreMixin(ScheduleStore)]

  getInitialState: ->
    schedule: false

  onChange: ->
    @setState schedule: true

  componentDidMount: ->
    AppActions.getSchedule @props.scheduleId

  renderContent: ->
    WeekCalendar {}

  render: ->
    R.div className: "pla-content container-fluid",
      R.section className: "pla-schedule-page",
        if @state.schedule is true
          @renderContent()
        else
          LoadingView {}

)

module.exports = SchedulePage
