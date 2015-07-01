
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
