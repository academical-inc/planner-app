
_             = require '../utils/Utils'
Store         = require './Store'
SectionStore  = require './SectionStore'
SchoolStore   = require './SchoolStore'
{ActionTypes} = require '../constants/PlannerConstants'


fields = ->
  fds = SchoolStore.school().appUi.summaryFields
  fds.map (f)->
    if typeof f.field is 'string'
      _.camelize f.field
    else
      f.field


# TODO Tests
class SummaryDialogStore extends Store

  summary: ->
    fds      = fields()
    sections = SectionStore.sections()

    sections.map (section)->
      fds.map (f)->
        if f.list?
          val = _.getNested section, _.camelize(f.list)
          res = val.map (el)-> el[f.field]
          res.join ", "
        else
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
