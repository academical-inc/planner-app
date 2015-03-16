
$              = require 'jquery'
React          = require 'react'
SectionStore   = require '../stores/SectionStore'
PreviewStore   = require '../stores/PreviewStore'
EventStore     = require '../stores/EventStore'
EventUtils     = require '../utils/EventUtils'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
R              = React.DOM

# Private
sectionEvents = -> SectionStore.sectionEvents()
previewEvents = -> PreviewStore.previewEvents()
events        = -> EventStore.expandedEvents()


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

  eventDataTransform: (event)->
    parent = event.parent
    ev     = event.ev
    id:              parent.id
    title:           if parent.dirty then "Saving..." else parent.name
    description:     parent.description
    start:           ev.startDt
    end:             ev.endDt
    location:        parent.location
    className:       'dirty-event' if parent.dirty
    backgroundColor: parent.color
    borderColor:     parent.color
    del:             parent.del
    editable:        true
    allDay:          false
    isEvent:         true

  updateEventSource: (source, events)->
    @cal.fullCalendar "removeEventSource", source
    source.events = events
    @cal.fullCalendar "addEventSource", source

  onSectionsChange: ->
    @updateEventSource @sources.sections, sectionEvents()

    # TODO temporal
    # if @sources.sections.events.length > 0
    #   @cal.fullCalendar "gotoDate", @sources.sections.events[0].event.startDt

  onPreviewChange: ->
    @updateEventSource @sources.preview, previewEvents()

  onEventsChange: ->
    @updateEventSource @sources.events, events()

  removeSection: (sectionId)->
    PlannerActions.removeSection sectionId

  removeEvent: (eventId)->
    PlannerActions.removeEvent eventId

  handleEventSelect: (start, end)->
    @cal.fullCalendar 'unselect'
    PlannerActions.openEventForm start, end

  componentDidMount: ->
    SectionStore.addChangeListener @onSectionsChange
    PreviewStore.addChangeListener @onPreviewChange
    EventStore.addChangeListener @onEventsChange
    @cal = $(@getDOMNode())
    @sources =
      sections:
        events: []
        eventDataTransform: @sectionEventDataTransform
        backgroundColor: UiConstants.defaultSectionColor
        borderColor: UiConstants.defaultSectionColor
      preview:
        events: []
        eventDataTransform: @previewEventDataTransform
      events:
        events: []
        eventDataTransform: @eventDataTransform
        backgroundColor: UiConstants.defaultPevColor
        borderColor: UiConstants.defaultPevColor

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
      select: @handleEventSelect
    )

  componentWillUnmount: ->
    SectionStore.removeChangeListener @onSectionsChange
    PreviewStore.removeChangeListener @onPreviewChange
    EventStore.removeChangeListener @onEventsChange

  renderEvent: (event, jqElement)->
    icon = if event.del is true
      @spinnerMarkup classNames: ['pull-right']
    else
      @iconMarkup "times", fw: false, inverse: true, classNames: ['pull-right']

    icon = $(icon)
    if event.isSection
      icon.on "click", @removeSection.bind(@, event.id)
    else if event.isEvent
      icon.on "click", @removeEvent.bind(@, event.id) if not(event.del is true)
    jqElement.find('.fc-time').append icon
    jqElement

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
