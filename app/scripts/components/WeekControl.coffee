
React            = require 'react'
I18nMixin        = require '../mixins/I18nMixin'
PlannerConstants = require '../constants/PlannerConstants'
R                = React.DOM

selectors = PlannerConstants.UiConstants.selectors
commands  = PlannerConstants.WeekCalendarCommands

WeekControl = React.createClass(

  mixins: [I18nMixin]

  handlePrev: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.PREV

  handleToday: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.TODAY

  handleNext: ->
    $(selectors.WEEK_CALENDAR).fullCalendar commands.NEXT

  render: ->
    R.li className: 'pla-week-control',
      R.div
        className: "control arrow-left",
        onClick: @handlePrev
        R.img src: '/images/previous_arrow.png'
      R.div
        className: "control today",
        onClick: @handleToday
        @t("week.today")
      R.div
        className: "control arrow-right",
        onClick: @handleNext
        R.img src: '/images/next_arrow.png'

)

module.exports = WeekControl
