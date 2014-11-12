
React             = require 'react'
C                 = require '../constants/PlannerConstants'
PanelItemList     = React.createFactory require './PanelItemList'
SectionItem       = React.createFactory require './SectionItem'
PersonalEventItem = React.createFactory require './PersonalEventItem'
R                 = React.DOM

ScheduleInfoBar = React.createClass(

  render: ->
    R.div className: "pla-schedule-info-bar",
      PanelItemList
        itemType: SectionItem
        header: "Classes: 2 Credits: 6"
        initialState: [
          {
            id: "1"
            name: "MATE1203 - Algebra"
          },
          {
            id: "2"
            name: "LANG1505 - Spanish"
          }
        ]
      PanelItemList
        itemType: PersonalEventItem
        header: "Other Events"
        itemAddDataToggle: "modal"
        itemAddDataTarget: C.selectors.PERSONAL_EVENT_MODAL
        initialState: [
          {
            id: "1"
            name: "Gym"
          },
          {
            id: "2"
            name: "Sexy Time"
          }
        ]

)

module.exports = ScheduleInfoBar

