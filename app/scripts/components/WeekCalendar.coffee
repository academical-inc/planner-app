
$             = require 'jquery'
React         = require 'react'
SectionStore  = require '../stores/SectionStore'
I18nMixin     = require '../mixins/I18nMixin'
R             = React.DOM

WeekCalendar = React.createClass(

  mixins: [I18nMixin]

  sections: ->
    SectionStore.getCurrentSections()

  getSectionEvents: (sections=@sections())->
    sections.reduce(
      (prevArr, curSec)->
        allSectionEvents = curSec.events.reduce(
          (prevEvArr, ev)->
            prevEvArr.concat ev.expanded.map (e)->
              section: curSec, event: e
          , []
        )
        prevArr.concat allSectionEvents
      , []
    )

  sectionEventDataTransform: (sectionEventData)->
    id:           sectionEventData.section.id
    title:        sectionEventData.section.courseName
    description:  sectionEventData.section.courseDescription
    start:        sectionEventData.event.startDt
    end:          sectionEventData.event.endDt
    location:     sectionEventData.event.location
    editable:     false
    allDay:       false

  onSectionsChange: ->
    @cal.fullCalendar "removeEventSource", @sources.sections
    @sources.sections.events = @getSectionEvents()
    @cal.fullCalendar "addEventSource", @sources.sections

    # TODO temporal
    if @sources.sections.events.length > 0
      @cal.fullCalendar "gotoDate", @sources.sections.events[0].event.startDt

  componentDidMount: ->
    SectionStore.addChangeListener @onSectionsChange
    @cal = $(@getDOMNode())
    @sources =
      sections:
        events: []
        eventDataTransform: @sectionEventDataTransform

    @cal.fullCalendar(
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

  componentWillUnmount: ->
    SectionStore.removeChangeListener @onSectionsChange

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
