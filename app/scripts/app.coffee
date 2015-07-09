
# Init School
school      = require('./Env').SCHOOL
AppActions  = require './actions/AppActions'
AppActions.initSchool school

# Require Modules
_           = require './utils/Utils'
Bugsnag     = require './utils/Bugsnag'
Router      = require './utils/Router'
I18n        = require './utils/I18n'
ApiUtils    = require './utils/ApiUtils'
UserStore   = require './stores/UserStore'
AuthError   = require './errors/AuthError'
{Pages}     = require './constants/PlannerConstants'

# Library Initializers (Patchers)
require './initializers/bootstrap'

# Init modules
Bugsnag.init()
Router.init()
ApiUtils.init()
I18n.init if _.qs("lang")? then _.qs("lang") else school.locale

# Routes
defRoute = Router.defRoute
goTo     = Router.goTo

# Check for route overrides in state.
Router.redirect _.hs('state') if _.hs('state')?

defRoute '/', ->
  try
    initialScheduleId = _.qs('open-schedule') if _.qs('open-schedule')
    if UserStore.isLoggedIn()
      AppActions.logout()
      goTo Pages.APP, ui: school.appUi, initialScheduleId: initialScheduleId
    else
      goTo Pages.LANDING
  catch e
    if e instanceof AuthError
      goTo Pages.LANDING, error: e.message
    else
      # TODO - FIX THIS SHIT
      Bugsnag.notify e
      console.error e
      goTo Pages.ERROR, msg: e.message

defRoute '/schedules/:scheduleId', (ctx)->
  if UserStore.isLoggedIn()
    AppActions.logout()
  goTo Pages.SINGLE_SCHEDULE, scheduleId: ctx.params.scheduleId

Router.route()
