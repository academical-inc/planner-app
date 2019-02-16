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

React           = require 'react'
_               = require '../utils/Utils'
PollUtils       = require '../utils/PollUtils'
Tutorial        = require '../utils/Tutorial'
StoreMixin      = require '../mixins/StoreMixin'
UserStore       = require '../stores/UserStore'
AppActions      = require '../actions/AppActions'
LoadingView     = React.createFactory require './LoadingView'
AppBody         = React.createFactory require './AppBody'
SlideMenuHandle = React.createFactory require './SlideMenuHandle'
AppModals       = React.createFactory require './AppModals'
AppHeader       = React.createFactory require './AppHeader'
R               = React.DOM

{AuthConstants: {TOKEN_EXPIRATION_MS},
POLL_INTERVAL}  = require '../constants/PlannerConstants'


# Private
_init = _.debounce(
  (userId, initialScheduleId)->
    AppActions.getSchedules userId, initialScheduleId
    PollUtils.poll userId
    Tutorial.init userId
    return
  , 0
)

# TODO Test
AppPage = React.createClass(

  mixins: [StoreMixin(UserStore)]

  getState: ->
    userId: UserStore.user().id

  getInitialState: ->
    @getState()

  onChange: ->
    if UserStore.user()?
      @setState @getState()
    else
      PollUtils.clear()

  componentDidMount: ->
    if @state.userId?
      _init @state.userId, @props.initialScheduleId
    else
      # Prevent ActionDispatch within an action
      setTimeout (-> AppActions.fetchUser(UserStore.user())), 0

  componentWillUpdate: (nextProps, nextState)->
    if not @state.userId? and nextState.userId?
      _init nextState.userId, @props.initialScheduleId

  render: ->
    if @state.userId?
      R.div className: 'pla-content container-fluid',
        SlideMenuHandle({})
        AppHeader({})
        AppBody ui: @props.ui
        AppModals ui: @props.ui
    else
      R.div className: 'pla-content container-fluid',
        LoadingView {}
        AppModals ui: @props.ui

)

module.exports = AppPage
