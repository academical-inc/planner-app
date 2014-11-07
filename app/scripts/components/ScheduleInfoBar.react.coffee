
React             = require 'react'
PanelItemList     = require './PanelItemList.react'
SectionItem       = require './SectionItem.react'
PersonalEventItem = require './PersonalEventItem.react'
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

