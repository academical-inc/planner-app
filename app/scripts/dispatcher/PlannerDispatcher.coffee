
{PayloadSources} = require '../constants/PlannerConstants'
{Dispatcher}     = require 'flux'


PlannerDispatcher = new Dispatcher()

PlannerDispatcher.handleServerAction = (action)->
  payload =
    source: PayloadSources.SERVER_ACTION
    action: action
  @dispatch payload

PlannerDispatcher.handleViewAction = (action)->
  payload =
    source: PayloadSources.VIEW_ACTION
    action: action
  @dispatch payload


module.exports = PlannerDispatcher
