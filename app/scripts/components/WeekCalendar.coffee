
$               = require 'jquery'
React           = require 'react'
SchoolStore     = require '../stores/SchoolStore'
SectionStore    = require '../stores/SectionStore'
ColorStore      = require '../stores/SectionColorStore'
PreviewStore    = require '../stores/PreviewStore'
EventStore      = require '../stores/EventStore'
_               = require '../utils/Utils'
DateUtils       = require '../utils/DateUtils'
I18nMixin       = require '../mixins/I18nMixin'
IconMixin       = require '../mixins/IconMixin'
StoreMixin      = require '../mixins/StoreMixin'
AppActions      = require '../actions/AppActions'
{UiConstants}   = require '../constants/PlannerConstants'
{CalendarDates} = require '../constants/PlannerConstants'
R               = React.DOM

# Private
_school        = SchoolStore.school()
_term          = _school.terms[0]
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

  setDefaultDate : ->
    beforeTermStart = SchoolStore.nowIsBeforeTermStart()
    afterTermEnd = SchoolStore.nowIsAfterTermEnd()
    if beforeTermStart || @props.defaultDate == CalendarDates.TERM_START
      _term.startDate
    else if afterTermEnd || @props.defaultDate == CalendarDates.TERM_END
      _term.endDate

  sectionEventDataTransform: (event)->
    section = event.parent

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

  previewEventDataTransform: (event)->
    id:              event.parent.id
    start:           event.startDt
    end:             event.endDt
    backgroundColor: 'red' if event.isOverlapping
    borderColor:     'red' if event.isOverlapping
    className:       'dirty-event'
    editable:        false
    allDay:          false
    isPreview:       true

  eventDataTransform: (ev)->
    parent  = ev.parent
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
    AppActions.removeSection sectionId

  removeEvent: (eventId)->
    AppActions.removeEvent eventId

  handleSelect: (start, end)->
    @cal.fullCalendar 'unselect'
    AppActions.openEventForm start, end

  handleEventUpdate: (event, delta)->
    start = DateUtils.inUtcOffset event.start, _school.utcOffset
    end   = DateUtils.inUtcOffset event.end, _school.utcOffset
    AppActions.updateEvent event.id, start, end, delta.days()

  handleSetWeek: (fcView)->
    _.debounce(AppActions.setWeek.bind(AppActions, fcView.start), 0)()

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

    defaultDate = @setDefaultDate()

    @cal.fullCalendar(
      defaultView: "agendaWeek"
      defaultDate: defaultDate if defaultDate?
      allDaySlot: false
      allDayText: false
      dayNamesShort: @t "calendar.days"
      scrollTime: "07:00:00"
      minTime: "06:00:00"
      columnFormat:
        week: 'ddd - MMM D'
      firstDay: 1
      weekends: true
      editable: true
      selectable: true
      header: false
      eventRender: @renderEvent
      select: @handleSelect
      eventDrop: @handleEventUpdate
      eventResize: @handleEventUpdate
      viewRender: @handleSetWeek
    )

  renderEvent: (event, jqElement)->
    if not (event.isPreview)
      icon = if event.del is true
        @spinnerMarkup className: 'pull-right'
      else
        @imgIcon '/images/remove_icon.png',
          className: 'remove-event-icon pull-right'
          markup: true

      icon = $(icon)
      if event.isSection
        icon.on "click", @removeSection.bind(@, event.id)
      else if event.isEvent and not(event.del is true)
        icon.on "click", @removeEvent.bind(@, event.id)
      jqElement.find('.fc-time').append icon
      if !!event.location
        loc = "#{@t('in')} #{event.location}"
        jqElement.find('.fc-title').append $('<br/><br/>')
        jqElement.find('.fc-title').append loc
    jqElement

  render: ->
    R.div className: 'pla-week-calendar', id: UiConstants.ids.WEEK_CALENDAR

)

module.exports = WeekCalendar
