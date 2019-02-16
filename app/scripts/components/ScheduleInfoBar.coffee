#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
        className: "pla-section-list"
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
        className: "pla-event-list"
        itemType: EventItem
        header: @t "sidebar.eventsHeader"
        handleItemAdd: @handleEventAdd
        handleItemDelete: @handleEventRemove
        items: @state.events

)

module.exports = ScheduleInfoBar

