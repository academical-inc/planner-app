
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
        payload       = errorPayload err, response
        payload.type  = errorAction
        payload.error = err
        PlannerDispatcher.dispatchServerAction payload
      else
        payload      = successPayload response
        payload.type = successAction
        PlannerDispatcher.dispatchServerAction payload
      return


module.exports = ActionUtils
