
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{saveSchedule}    = require './ScheduleActions'


class SectionActions

  @addSection: (section, color)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.ADD_SECTION
      section: section
      color: color
    saveSchedule()

  @changeSectionColor: (sectionId, color)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CHANGE_SECTION_COLOR
      sectionId: sectionId
      color: color
    saveSchedule()

  @removeSection: (sectionId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.REMOVE_SECTION
      sectionId: sectionId
    saveSchedule()

  @addPreview: (section, previewType)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.ADD_SECTION_PREVIEW
      previewType: previewType
      section: section

  @removePreview: (previewType)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.REMOVE_SECTION_PREVIEW
      previewType: previewType


module.exports = SectionActions
