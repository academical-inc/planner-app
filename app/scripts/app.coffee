
# Init School
school      = require('./Env').SCHOOL
AppActions  = require './actions/AppActions'
AppActions.initSchool school

# Require Modules
_           = require './utils/Utils'
Router      = require './utils/Router'
I18n        = require './utils/I18n'
ApiUtils    = require './utils/ApiUtils'
UserStore   = require './stores/UserStore'
{Pages}     = require './constants/PlannerConstants'

{POLL_INTERVAL} = require './constants/PlannerConstants'


# Library Initializers (Patchers)
require './initializers/bootstrap'


# Init modules
Router.init()
ApiUtils.init()
I18n.init if _.qs("lang")? then _.qs("lang") else school.locale


# Routes
defRoute = Router.defRoute
goTo     = Router.goTo

defRoute '/', ->
  if UserStore.isLoggedIn()
    AppActions.getSchedules()
    # TODO Tests
    # OK because POLL_INTERVAL will always be sufficiently big
    setInterval AppActions.updateSchedules, POLL_INTERVAL
    goTo Pages.APP, ui: school.appUi
  else
    goTo Pages.LANDING


defRoute '/schedules/:scheduleId', (ctx)->
  goTo Pages.SINGLE_SCHEDULE, scheduleId: ctx.params.scheduleId

Router.route()
