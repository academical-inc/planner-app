
$                  = require 'jquery'
React              = require 'react'
SectionStore       = require '../stores/SectionStore'
PreviewStore       = require '../stores/PreviewStore'
PersonalEventStore = require '../stores/PersonalEventStore'
EventUtils         = require '../utils/EventUtils'
I18nMixin          = require '../mixins/I18nMixin'
IconMixin          = require '../mixins/IconMixin'
PlannerActions     = require '../actions/PlannerActions'
{UiConstants}      = require '../constants/PlannerConstants'
R                  = React.DOM

# Private
sectionEvents  = -> SectionStore.getCurrentSectionEvents()
previewEvents  = -> PreviewStore.getPreviewEvents()
personalEvents = -> PersonalEventStore.getPersonalEvents()


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

  personalEventDataTransform: (personalEvent)->
    title:           personalEvent.name
    description:     personalEvent.description
    start:           personalEvent.startDt
    end:             personalEvent.endDt
    location:        personalEvent.location
    backgroundColor: personalEvent.color
    borderColor:     personalEvent.color
    pev:             personalEvent
    editable:        true
    allDay:          false
    isPev:           true

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

  onPersonalEventsChange: ->
    @updateEventSource @sources.personalEvents, personalEvents()

  removeSection: (sectionId)->
    PlannerActions.removeSection sectionId

  removePersonalEvent: (pev)->
    PlannerActions.removePersonalEvent pev

  handleEventSelect: (start, end)->
    @cal.fullCalendar 'unselect'
    PlannerActions.openPersonalEventForm start, end

  componentDidMount: ->
    SectionStore.addChangeListener @onSectionsChange
    PreviewStore.addChangeListener @onPreviewChange
    PersonalEventStore.addChangeListener @onPersonalEventsChange
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
      personalEvents:
        events: []
        eventDataTransform: @personalEventDataTransform
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
    PersonalEventStore.removeChangeListener @onPersonalEventsChange

  renderEvent: (event, jqElement)->
    icon = $(
      @iconMarkup "times", fw: false, inverse: true, classNames: ['pull-right']
    )
    if event.isSection
      icon.on "click", @removeSection.bind(@, event.id)
    else if event.isPev
      icon.on "click", @removePersonalEvent.bind(@, event.pev)
    jqElement.find('.fc-time').append icon
    jqElement

  render: ->
    R.div className: 'pla-week-calendar'

)

module.exports = WeekCalendar
