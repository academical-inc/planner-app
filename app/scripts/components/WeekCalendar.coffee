
React     = require 'react'
$         = require 'jquery'
I18nMixin = require '../mixins/I18nMixin'
R         = React.DOM

WeekCalendar = React.createClass(

  mixins: [I18nMixin]

  componentDidMount: ->
    $(@getDOMNode()).fullCalendar(
      defaultView: "agendaWeek"
      allDaySlot: false
      allDayText: false
      dayNamesShort: @t "calendar.days"
      scrollTime: "07:00:00"
      firstDay: 1
      weekends: true
      editable: true
      selectable: true
      header:
        left: "prev"
        center: @t "calendar.today"
        right: "next"
    )

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
