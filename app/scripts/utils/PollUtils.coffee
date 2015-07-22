
AppActions = require '../actions/AppActions'

{AuthConstants: {TOKEN_EXPIRATION_MS},
POLL_INTERVAL}  = require '../constants/PlannerConstants'


# Private
_interval = null

_performPoll = (userId, untTimestamp, now)->
  now ?= new Date().valueOf()
  if now > untTimestamp
    PollUtils.clear()
    AppActions.logout()
  else
    AppActions.updateSchedules userId

# TODO Test
class PollUtils

  @clear: ->
    clearInterval _interval

  @poll: (userId, {untTimestamp, pollInterval, pollFunc, now}={})->
    pollFunc     ?= _performPoll
    pollInterval ?= POLL_INTERVAL
    untTimestamp ?= new Date().valueOf() + TOKEN_EXPIRATION_MS
    _interval = setInterval(
      # OK because POLL_INTERVAL will always be sufficiently big
      pollFunc.bind(null, userId, untTimestamp, now), pollInterval
    )


module.exports = PollUtils
