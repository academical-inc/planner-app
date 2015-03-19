
React          = require 'react'
PlannerActions = require '../actions/PlannerActions'
SectionStore   = require '../stores/SectionStore'
EventStore     = require '../stores/EventStore'
I18nMixin      = require '../mixins/I18nMixin'
StoreMixin     = require '../mixins/StoreMixin'
PanelItemList  = React.createFactory require './PanelItemList'
SectionItem    = React.createFactory require './SectionItem'
EventItem      = React.createFactory require './EventItem'
R              = React.DOM

ScheduleInfoBar = React.createClass(

  mixins: [I18nMixin, StoreMixin(SectionStore, EventStore)]

  getState: ->
    totalSections: SectionStore.count()
    totalCredits: SectionStore.credits()
    sections: SectionStore.sections()
    events: EventStore.events()

  getInitialState: ->
    @props.initialState or @getState()

  handleEventAdd: ->
    PlannerActions.openEventForm()

  handleEventRemove: (event)->
    PlannerActions.removeEvent event.id

  handleSectionRemove: (section)->
    PlannerActions.removeSection section.id

  onChange: ->
    @setState @getState()

  render: ->
    R.div className: "pla-schedule-info-bar",
      PanelItemList
        itemType: SectionItem
        header: @t "sidebar.sectionsHeader", sections: @state.totalSections,\
          credits: @state.totalCredits
        handleItemDelete: @handleSectionRemove
        items: @state.sections
      PanelItemList
        itemType: EventItem
        header: @t "sidebar.eventsHeader"
        handleItemAdd: @handleEventAdd
        handleItemDelete: @handleEventRemove
        items: @state.events

)

module.exports = ScheduleInfoBar

