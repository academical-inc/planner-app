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

React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
AppActions  = require '../actions/AppActions'
WeekControl = React.createFactory require './WeekControl'
R           = React.DOM

SchedulePageHeader = React.createClass(

  mixins: [I18nMixin]

  renderDuplicateButton: (loggedIn) ->
    onClickHandler = @props.duplicateScheduleHandler
    duplicateMessage = 'duplicateSchedule'
    if !loggedIn
      onClickHandler = @props.loginHandler
      duplicateMessage = 'loginToDuplicate'

    R.button className: 'btn btn-default', onClick: onClickHandler,
      R.img src: '/images/add_schedule_icon.png'
      R.span null, @t duplicateMessage

  render: ->
    loggedIn = @props.loggedIn
    R.section className: 'pla-schedule-header hidden-xs hidden-sm',
      R.nav className: 'navbar', role: 'navigation',
        R.div className: 'container-fluid',
          R.ul className: 'nav navbar-nav',
            R.div className: 'pla-logo-container',
              R.span className: 'vertical-align-helper'
              R.img src: '/images/academical_logo_blue.png'
          R.ul className: 'nav navbar-nav pla-week-container',
            R.span className: "vertical-align-helper", null
            WeekControl {}
          R.ul className: 'nav navbar-nav',
            R.span className: 'vertical-align-helper', null
            R.div className: 'pla-schedule-button',
              @renderDuplicateButton loggedIn
)

module.exports = SchedulePageHeader

