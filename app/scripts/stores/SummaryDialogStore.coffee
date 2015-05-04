
$             = require 'jquery'
Humps         = require 'humps'
Store         = require './Store'
SectionStore  = require './SectionStore'
ApiUtils      = require '../utils/ApiUtils'
{ActionTypes} = require '../constants/PlannerConstants'


fields = ->
  fds = ApiUtils.currentSchool().appUi.summaryFields
  fds.map (f)->
    Humps.camelize f.field


class SummaryDialogStore extends Store

  summary: ->
    fds      = fields()
    sections = SectionStore.sections()

    sections.map (section)->
      fds.map (f)->
        val = section
        f.split(".").forEach (part)->
          val = val[part]
        if $.isArray val
          val.join ", "
        else
          val


  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SUMMARY_DIALOG
        @emitChange()


module.exports = new SummaryDialogStore