
# Init School
Env         = require './Env'
school      = Env.SCHOOL
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

# TODO this was a hack to allow users that login from the schedule page to be
# redirected to the schedule page upon login. We should have a better way of
# doing this
# Check for route overrides in state.
# Router.redirect _.hs('state') if _.hs('state')?

defRoute '/', ->
  try
    initialScheduleId = _.qs('open-schedule') if _.qs('open-schedule')
    if UserStore.isLoggedIn()
      AppActions.logout() if Env.CLOSED
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
  if Env.CLOSED and UserStore.isLoggedIn()
    AppActions.logout()
  goTo Pages.SINGLE_SCHEDULE, scheduleId: ctx.params.scheduleId

Router.route()
