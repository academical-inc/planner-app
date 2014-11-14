
React             = require 'react'
C                 = require '../constants/PlannerConstants'
PanelItemList     = React.createFactory require './PanelItemList'
SectionItem       = React.createFactory require './SectionItem'
PersonalEventItem = React.createFactory require './PersonalEventItem'
R                 = React.DOM

ScheduleInfoBar = React.createClass(

  getInitialState: ->
    @props.initialState || {
      totalCredits: 6
      totalSections: 2
      sections: [
        {
          id: "1"
          name: "MATE1203 - Algebra"
        },
        {
          id: "2"
          name: "LANG1505 - Spanish"
        }
      ]
      personalEvents: [
        {
          id: "1"
          name: "Gym"
        },
        {
          id: "2"
          name: "Sexy Time"
        }
      ]
    }

  render: ->
    R.div className: "pla-schedule-info-bar",
      PanelItemList
        itemType: SectionItem
        header: "Sections: #{@state.totalSections} Credits:
                #{@state.totalCredits}"
        initialState: @state.sections
      PanelItemList
        itemType: PersonalEventItem
        header: "Other Events"
        itemAddDataToggle: "modal"
        itemAddDataTarget: C.selectors.PERSONAL_EVENT_MODAL
        initialState: @state.personalEvents

)

module.exports = ScheduleInfoBar

