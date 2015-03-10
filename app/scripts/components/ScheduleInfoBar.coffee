
React          = require 'react'
$              = require 'jquery'
I18nMixin      = require '../mixins/I18nMixin'
PlannerActions = require '../actions/PlannerActions'
PanelItemList  = React.createFactory require './PanelItemList'
SectionItem    = React.createFactory require './SectionItem'
EventItem      = React.createFactory require './EventItem'
R              = React.DOM

ScheduleInfoBar = React.createClass(

  mixins: [I18nMixin]

  getInitialState: ->
    @props.initialState || {
      totalCredits: 6
      totalSections: 2
      sections: [
        {
          id: "5fb6679adb55"
          sectionId:  "45578"
          sectionNumber: 2
          courseName: "Algebra"
          courseCode: "MATE1203"
          seats:
            available: 20
          teacherNames: ["Dimitri Alejo", "Juan Tejada"]
          credits: 3
          departments: [{name: "Math Department"}]
        }
        {
          id: "5fb6679adb54"
          sectionId:  "37442"
          sectionNumber: 2
          courseName: "Spanish"
          courseCode: "LANG1550"
          seats:
            available: 5
          teacherNames: ["Gregorio Hernandez"]
          credits: 3
          departments: [{name: "Foreign Languages"}]
        }
        {
          id: "5fb6679ad499"
          sectionId:  "12345"
          sectionNumber: 1
          courseName: "Physics 1"
          courseCode: "FISI2222"
          seats:
            available: 15
          teacherNames: ["Manolo Rodriguez, Lorena Hernandez"]
          credits: 3
          departments: [{name: "Physics"}]
        }
      ]
      events: [
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

  handleEventAdd: ->
    PlannerActions.openEventForm()

  render: ->
    R.div className: "pla-schedule-info-bar",
      PanelItemList
        itemType: SectionItem
        header: @t "sidebar.sectionsHeader", sections: @state.totalSections,\
          credits: @state.totalCredits
        items: @state.sections
      PanelItemList
        itemType: EventItem
        header: @t "sidebar.eventsHeader"
        handleItemAdd: @handleEventAdd
        items: @state.events

)

module.exports = ScheduleInfoBar

