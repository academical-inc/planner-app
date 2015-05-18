
ExportUtils       = require '../utils/ExportUtils'
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


module.exports = ExportActions
