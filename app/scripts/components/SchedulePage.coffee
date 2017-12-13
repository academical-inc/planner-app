
React              = require 'react'
StoreMixin         = require '../mixins/StoreMixin'
ScheduleStore      = require '../stores/ScheduleStore'
UserStore          = require '../stores/UserStore'
AppActions         = require '../actions/AppActions'
{CalendarDates}    = require '../constants/PlannerConstants'
LoadingView        = React.createFactory require './LoadingView'
WeekCalendar       = React.createFactory require './WeekCalendar'
LoginDialog        = React.createFactory require './LoginDialog'
ErrorDialog        = React.createFactory require './ErrorDialog'
SchedulePageHeader = React.createFactory require './SchedulePageHeader'
Router             = require '../utils/Router'
R                  = React.DOM


SchedulePage = React.createClass(

  mixins: [StoreMixin(
    {store: ScheduleStore, handler: 'onScheduleChange'}
    {store: UserStore, handler: 'onUserChange'}
  )]

  getUserState: ->
    loggedIn : UserStore.isLoggedIn()
    userId   : UserStore.user().id if UserStore.user()

  getInitialState: ->
    state = @getUserState()
    state.schedule = false
    state

  onScheduleChange: ->
    numberOfSchedules = ScheduleStore.all().length
    currentSchedule = ScheduleStore.current()
    scheduleLoaded = true
    # Once schedule has been duplicated, send us back to the app.
    if numberOfSchedules == 2
      scheduleLoaded = false
      if !currentSchedule.dirty
        scheduleId = currentSchedule.id
        Router.redirect "/?open-schedule=#{scheduleId}", true
    @setState schedule: scheduleLoaded

  onUserChange: ->
    @setState @getUserState()

  componentDidMount: ->
    AppActions.getSchedule @props.scheduleId

  promptForLogin: ->
    @refs.loginDialog.show()
    @refs.loginDialog.registerOnLoginCallback(->
      Router.createRedirectRequest window.location.pathname
    )

  duplicateSchedule: ->
    userId = @state.userId
    AppActions.duplicateSchedule(userId)

  renderContent: ->
    R.div className: "pla-schedule-page",
      SchedulePageHeader loggedIn: @state.loggedIn,
      loginHandler: @promptForLogin,
      duplicateScheduleHandler: @duplicateSchedule
      R.section className: "pla-schedule-body",
        R.div className: 'pla-schedule-container',
          WeekCalendar defaultDate: CalendarDates.TERM_START
      LoginDialog ref: "loginDialog"
      ErrorDialog ref: "errorDialog"

  render: ->
    R.div className: "pla-content container-fluid",
      if @state.schedule is true
        @renderContent()
      else
        LoadingView {}
)

module.exports = SchedulePage
