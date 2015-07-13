
React         = require 'react'
AppActions    = require '../actions/AppActions'
SchoolStore   = require '../stores/SchoolStore'
SectionStore  = require '../stores/SectionStore'
ColorStore    = require '../stores/SectionColorStore'
EventStore    = require '../stores/EventStore'
I18nMixin     = require '../mixins/I18nMixin'
StoreMixin    = require '../mixins/StoreMixin'
PanelItemList = React.createFactory require './PanelItemList'
SectionItem   = React.createFactory require './SectionItem'
EventItem     = React.createFactory require './EventItem'
R             = React.DOM

ScheduleInfoBar = React.createClass(

  mixins: [I18nMixin, StoreMixin(SectionStore, EventStore, ColorStore)]

  getState: ->
    totalSections: SectionStore.count()
    totalCredits: SectionStore.credits()
    sections: SectionStore.sections()
    sectionColors: ColorStore.colors()
    events: EventStore.eventsExceptDirtyAdded()

  getInitialState: ->
    @props.initialState or @getState()

  handleEventAdd: ->
    AppActions.openEventForm()

  handleEventRemove: (event)->
    AppActions.removeEvent event.id

  handleSectionRemove: (section)->
    AppActions.removeSection section.id

  onChange: ->
    @setState @getState()

  render: ->
    school = SchoolStore.school().nickname
    R.div className: "pla-schedule-info-bar",
      PanelItemList
        itemType: SectionItem
        header: @t "sidebar.sectionsHeader"
        subheader: @t(
          "sidebar.sectionsHeaderInfo.#{school}"
          sections: @state.totalSections
          credits: @state.totalCredits
        )
        handleItemDelete: @handleSectionRemove
        items: @state.sections
        colors: @state.sectionColors
      PanelItemList
        itemType: EventItem
        header: @t "sidebar.eventsHeader"
        handleItemAdd: @handleEventAdd
        handleItemDelete: @handleEventRemove
        items: @state.events

)

module.exports = ScheduleInfoBar

