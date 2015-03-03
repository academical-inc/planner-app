
$              = require 'jquery'
React          = require 'react'
SectionStore   = require '../stores/SectionStore'
PreviewStore   = require '../stores/PreviewStore'
SectionUtils   = require '../utils/SectionUtils'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
PlannerActions = require '../actions/PlannerActions'
R              = React.DOM

# Private
sectionEvents = -> SectionStore.getCurrentSectionEvents()
previewEvents = -> PreviewStore.getPreviewEvents()


WeekCalendar = React.createClass(

  mixins: [I18nMixin, IconMixin]

  sectionEventDataTransform: (sectionEvent)->
    id:          sectionEvent.section.id
    title:       sectionEvent.section.courseName
    description: sectionEvent.section.courseDescription
    start:       sectionEvent.event.startDt
    end:         sectionEvent.event.endDt
    location:    sectionEvent.event.location
    editable:    false
    allDay:      false
    isSection:   true

  previewEventDataTransform: (sectionEvent)->
    id:              sectionEvent.section.id
    start:           sectionEvent.event.startDt
    end:             sectionEvent.event.endDt
    backgroundColor: 'red' if sectionEvent.event.isOverlapping
    rendering:       'background'
    editable:        false
    allDay:          false
    isPreview:       true

  updateEventSource: (source, events)->
    @cal.fullCalendar "removeEventSource", source
    source.events = events
    @cal.fullCalendar "addEventSource", source

  onSectionsChange: ->
    @updateEventSource @sources.sections, sectionEvents()

    # TODO temporal
    if @sources.sections.events.length > 0
      @cal.fullCalendar "gotoDate", @sources.sections.events[0].event.startDt

  onPreviewChange: ->
    @updateEventSource @sources.preview, previewEvents()

  removeSection: (sectionId)->
    PlannerActions.removeSection sectionId

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
      eventRender: @renderEvent
    )

  componentWillUnmount: ->
    SectionStore.removeChangeListener @onSectionsChange
    PreviewStore.removeChangeListener @onPreviewChange

  renderEvent: (event, jqElement)->
    icon = $(
      @iconMarkup "times", fw: false, inverse: true, classNames: ['pull-right']
    )
    if event.isSection
      icon.on "click", @removeSection.bind(@, event.id)
    jqElement.find('.fc-time').append icon
    jqElement

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
