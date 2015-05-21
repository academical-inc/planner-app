
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
    R.div className: 'pla-calendar-control',
      R.button
        onClick: @handlePrev
        className: "btn-arrow-left"
        R.img src: '/images/previous_arrow.png'
      R.button
        onClick: @handleToday
        className: "btn-day-tag"
        @t("week.today")
      R.button
        onClick: @handleNext
        className: "btn-arrow-right"
        R.img src: '/images/next_arrow.png'

)

module.exports = WeekControl
