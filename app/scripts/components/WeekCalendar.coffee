
$              = require 'jquery'
React          = require 'react'
SectionStore   = require '../stores/SectionStore'
ColorStore     = require '../stores/SectionColorStore'
PreviewStore   = require '../stores/PreviewStore'
EventStore     = require '../stores/EventStore'
DateUtils      = require '../utils/DateUtils'
ApiUtils       = require '../utils/ApiUtils'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
StoreMixin     = require '../mixins/StoreMixin'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
R              = React.DOM

# Private
_utcOffset     = -> ApiUtils.currentSchool().utcOffset
_sectionEvents = -> SectionStore.sectionEvents()
_sectionColors = -> ColorStore.colors()
_previewEvents = -> PreviewStore.allPreviewEvents()
_events        = -> EventStore.expandedEvents()


WeekCalendar = React.createClass(

  mixins: [I18nMixin, IconMixin, StoreMixin(
    {store: SectionStore, handler: "onSectionsChange"}
    {store: ColorStore, handler: "onSectionsChange"}
    {store: PreviewStore, handler: "onPreviewChange"}
    {store: EventStore, handler: "onEventsChange"}
  )]

  sectionEventDataTransform: (sectionEvent)->
    section = sectionEvent.section
    event   = sectionEvent.event

    id:              section.id
    title:           section.courseName
    description:     section.courseDescription
    start:           event.startDt
    end:             event.endDt
    location:        event.location
    backgroundColor: _sectionColors()[section.id]
    borderColor:     _sectionColors()[section.id]
    editable:        false
    allDay:          false
    isSection:       true

  previewEventDataTransform: (sectionEvent)->
    id:              sectionEvent.section.id
    start:           sectionEvent.event.startDt
    end:             sectionEvent.event.endDt
    backgroundColor: 'red' if sectionEvent.event.isOverlapping
    borderColor:     'red' if sectionEvent.event.isOverlapping
    className:       'dirty-event'
    editable:        false
    allDay:          false
    isPreview:       true

  eventDataTransform: (event)->
    parent  = event.parent
    ev      = event.ev
    isDirty = parent.dirtyAdd or parent.dirtyUpdate
    id:              parent.id
    title:           if isDirty then @t("calendar.saving") else parent.name
    description:     parent.description
    start:           ev.startDt
    end:             ev.endDt
    location:        parent.location
    className:       'dirty-event' if isDirty
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
    @updateEventSource @sources.sections, _sectionEvents()

  onPreviewChange: ->
    @updateEventSource @sources.preview, _previewEvents()

  onEventsChange: ->
    @updateEventSource @sources.events, _events()

  removeSection: (sectionId)->
    PlannerActions.removeSection sectionId

  removeEvent: (eventId)->
    PlannerActions.removeEvent eventId

  handleSelect: (start, end)->
    @cal.fullCalendar 'unselect'
    PlannerActions.openEventForm start, end

  handleEventUpdate: (event, delta)->
    start = DateUtils.inUtcOffset event.start, _utcOffset()
    end   = DateUtils.inUtcOffset event.end, _utcOffset()
    PlannerActions.updateEvent event.id, start, end, delta.days()

  handleWeekChange: (fcView)->
    PlannerActions.changeWeek fcView.start

  componentDidMount: ->
    @cal = $(@getDOMNode())
    @sources =
      sections:
        events: []
        eventDataTransform: @sectionEventDataTransform
      preview:
        events: []
        eventDataTransform: @previewEventDataTransform
        backgroundColor: UiConstants.DEFAULT_SECTION_COLOR
        borderColor: UiConstants.DEFAULT_SECTION_COLOR
      events:
        events: []
        eventDataTransform: @eventDataTransform

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
      header: false
      eventRender: @renderEvent
      select: @handleSelect
      eventDrop: @handleEventUpdate
      eventResize: @handleEventUpdate
      viewRender: @handleWeekChange
    )

  renderEvent: (event, jqElement)->
    if not (event.isPreview)
      icon = if event.del is true
        @spinnerMarkup className: 'pull-right'
      else
        @iconMarkup "times", fw: false, inverse: true, className: 'pull-right'

      icon = $(icon)
      if event.isSection
        icon.on "click", @removeSection.bind(@, event.id)
      else if event.isEvent and not(event.del is true)
        icon.on "click", @removeEvent.bind(@, event.id)
      jqElement.find('.fc-time').append icon
    jqElement

  render: ->
    R.div className: 'pla-week-calendar', id: UiConstants.ids.WEEK_CALENDAR

)

module.exports = WeekCalendar
