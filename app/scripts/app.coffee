#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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

defRoute '/', ->
  try
    if UserStore.isLoggedIn()
      AppActions.logout() if Env.CLOSED
      Router.executeRedirectRequests()

      initialScheduleId = _.qs('open-schedule') if _.qs('open-schedule')
      goTo Pages.APP, ui: school.appUi, initialScheduleId: initialScheduleId
    else
      goTo Pages.LANDING
  catch e
    Router.cleanRedirectRequests()
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
