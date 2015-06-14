
ApiUtils          = require '../utils/ApiUtils'
ActionUtils       = require '../utils/ActionUtils'
NavError          = require '../errors/NavError'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'


class SchoolActions

  @initSchool: (school)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.INIT_SCHOOL
      school: school
    return


module.exports = SchoolActions

