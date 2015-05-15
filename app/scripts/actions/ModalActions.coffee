
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class ModalActions

  @openEventForm: (startDt, endDt)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.OPEN_EVENT_FORM
      startDt: startDt
      endDt: endDt

  @openSummaryDialog: ->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.OPEN_SUMMARY_DIALOG


module.exports = ModalActions
