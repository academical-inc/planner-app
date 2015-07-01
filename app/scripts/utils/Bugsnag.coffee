
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
