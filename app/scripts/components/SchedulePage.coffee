#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
