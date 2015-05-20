
ApiUtils          = require '../utils/ApiUtils'
ExportUtils       = require '../utils/ExportUtils'
ActionUtils       = require '../utils/ActionUtils'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class ExportActions

  @exportToImage: (element)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.EXPORT_IMAGE

    ExportUtils.exportToImage element, (canvas)->
      PlannerDispatcher.dispatchViewAction
        type: ActionTypes.EXPORT_IMAGE_SUCCESS
        canvas: canvas
    return

  @exportToICS: (scheduleId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.EXPORT_ICS

    ApiUtils.getSchedule scheduleId, ActionUtils.handleServerResponse(
      ActionTypes.EXPORT_ICS_SUCCESS
      ActionTypes.EXPORT_ICS_FAIL
      (response)-> icsData: response
    ), format: 'ics'
    return


module.exports = ExportActions
