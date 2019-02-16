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

React            = require 'react'
I18nMixin        = require '../mixins/I18nMixin'
SchoolStore      = require '../stores/SchoolStore'
PlannerConstants = require '../constants/PlannerConstants'
R                = React.DOM

selectors = PlannerConstants.UiConstants.selectors
commands  = PlannerConstants.WeekCalendarCommands
termStart = SchoolStore.school().terms[0].startDate

WeekControl = React.createClass(

  mixins: [I18nMixin]

  handlePrev: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.PREV

  handleToday: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.TODAY

  handleClassStart: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.GOTO_DATE, termStart

  handleNext: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.NEXT

  render: ->
    showToday = not SchoolStore.nowIsBeforeTermStart()
    className = 'pla-week-control'
    className += ' class-start' if not showToday
    R.li className: className,
      R.div
        className: "control arrow-left",
        onClick: @handlePrev
        R.img src: '/images/previous_arrow.png'
      R.div
        className: "control today",
        onClick: if showToday then @handleToday else @handleClassStart
        if showToday then @t("week.today") else @t("week.classStart")
      R.div
        className: "control arrow-right",
        onClick: @handleNext
        R.img src: '/images/next_arrow.png'

)

module.exports = WeekControl
