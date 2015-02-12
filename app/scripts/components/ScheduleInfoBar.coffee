
React             = require 'react'
$                 = require 'jquery'
I18nMixin         = require '../mixins/I18nMixin'
{UiConstants}     = require '../constants/PlannerConstants'
PanelItemList     = React.createFactory require './PanelItemList'
SectionItem       = React.createFactory require './SectionItem'
PersonalEventItem = React.createFactory require './PersonalEventItem'
R                 = React.DOM

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

  handlePersonalEventAdd: ->
    $(UiConstants.selectors.PERSONAL_EVENT_MODAL).modal "show"

  render: ->
    R.div className: "pla-schedule-info-bar",
      PanelItemList
        itemType: SectionItem
        header: @t "sidebar.sectionsHeader", sections: @state.totalSections,\
          credits: @state.totalCredits
        items: @state.sections
      PanelItemList
        itemType: PersonalEventItem
        header: @t "sidebar.eventsHeader"
        handleItemAdd: @handlePersonalEventAdd
        items: @state.personalEvents

)

module.exports = ScheduleInfoBar

