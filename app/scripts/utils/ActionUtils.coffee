
AppError          = require '../errors/AppError'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'


# TODO Test
class ActionUtils

  @handleServerResponse: (
    successAction
    errorAction
    successPayload=->{}
    errorPayload=->{}
  )->
    (err, response)->
      if err?
        payload       = error: new AppError err
        payload       = $.extend true, {}, payload, errorPayload(err, response)
        payload.type  = errorAction
        PlannerDispatcher.dispatchServerAction payload
      else
        payload      = successPayload response
        payload.type = successAction
        PlannerDispatcher.dispatchServerAction payload
      return


module.exports = ActionUtils
