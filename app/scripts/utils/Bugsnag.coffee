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

Bugsnag   = require 'bugsnag-js'
Env       = require '../Env'
UserStore = require '../stores/UserStore'


class BugsnagUtils

  @init: ->
    Bugsnag.apiKey              = Env.BUGSNAG_API_KEY
    Bugsnag.releaseStage        = Env.APP_ENV
    Bugsnag.notifyReleaseStages = ["production", "staging"]
    UserStore.addChangeListener ->
      user = UserStore.user()
      Bugsnag.user = user if user? and user.id?

  @notify: (err, name, metadata, severity)->
    Bugsnag.notifyException err, name, metadata, severity


module.exports = BugsnagUtils
