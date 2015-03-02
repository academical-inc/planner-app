
$             = require 'jquery'
React         = require 'react'
SectionStore  = require '../stores/SectionStore'
PreviewStore  = require '../stores/PreviewStore'
SectionUtils  = require '../utils/SectionUtils'
I18nMixin     = require '../mixins/I18nMixin'
R             = React.DOM

# Private
sections = -> SectionStore.getCurrentSections()
preview  = -> PreviewStore.getPreview()
events   = (sections)-> SectionUtils.getSectionEvents(sections)

WeekCalendar = React.createClass(

  mixins: [I18nMixin]

  sectionEventDataTransform: (sectionEventData)->
    id:          sectionEventData.section.id
    title:       sectionEventData.section.courseName
    description: sectionEventData.section.courseDescription
    start:       sectionEventData.event.startDt
    end:         sectionEventData.event.endDt
    location:    sectionEventData.event.location
    editable:    false
    allDay:      false
    isSection:   true

  previewEventDataTransform: (sectionEventData)->
    id:              sectionEventData.section.id
    start:           sectionEventData.event.startDt
    end:             sectionEventData.event.endDt
    backgroundColor: 'red' if sectionEventData.event.isOverlapping
    rendering:       'background'
    editable:        false
    allDay:          false
    isPreview:       true

  onSectionsChange: ->
    @updateEventSource @sources.sections, events sections()

    # TODO temporal
    if @sources.sections.events.length > 0
      @cal.fullCalendar "gotoDate", @sources.sections.events[0].event.startDt

  onPreviewChange: ->
    @updateEventSource @sources.preview, events preview()

  updateEventSource: (source, events)->
    @cal.fullCalendar "removeEventSource", source
    source.events = events
    @cal.fullCalendar "addEventSource", source

  componentDidMount: ->
    SectionStore.addChangeListener @onSectionsChange
    PreviewStore.addChangeListener @onPreviewChange
    @cal = $(@getDOMNode())
    @sources =
      sections:
        events: []
        eventDataTransform: @sectionEventDataTransform
      preview:
        events: []
        eventDataTransform: @previewEventDataTransform

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
    PreviewStore.removeChangeListener @onPreviewChange

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
