
React         = require 'react'
IconMixin     = require '../mixins/IconMixin'
StoreMixin    = require '../mixins/StoreMixin'
ScheduleStore = require '../stores/ScheduleStore'
AppActions    = require '../actions/AppActions'
WeekCalendar  = React.createFactory require './WeekCalendar'
R             = React.DOM


SchedulePage = React.createClass(

  mixins: [IconMixin, StoreMixin(ScheduleStore)]

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
          R.div className: "loading-indicator",
            R.span className: "vertical-align-helper"
            @renderSpinner()

)

module.exports = SchedulePage
