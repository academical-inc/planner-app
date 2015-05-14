
_             = require '../utils/HelperUtils'
Store         = require './Store'
SectionStore  = require './SectionStore'
ApiUtils      = require '../utils/ApiUtils'
{ActionTypes} = require '../constants/PlannerConstants'


fields = ->
  fds = ApiUtils.currentSchool().appUi.summaryFields
  fds.map (f)->
    _.camelize f.field


# TODO Tests
class SummaryDialogStore extends Store

  summary: ->
    fds      = fields()
    sections = SectionStore.sections()

    sections.map (section)->
      fds.map (f)->
        val = _.getNested section, f
        if Array.isArray val
          val.join ", "
        else
          val


  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SUMMARY_DIALOG
        @emitChange()


module.exports = new SummaryDialogStore
