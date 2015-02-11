
PayloadSources = require('../constants/PlannerConstants').PayloadSources
Dispatcher     = require('flux').Dispatcher


PlannerDispatcher = new Dispatcher()


PlannerDispatcher.handleServerAction = (action)->
  payload:
    source: PayloadSource.SERVER_ACTION
    action: action
  @dispatch payload

PlannerDispatcher.handleViewAction = (action)->
  payload:
    source: PayloadSource.VIEW_ACTION
    action: action
  @dispatch payload


module.exports = PlannerDispatcher
