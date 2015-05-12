
Page           = require 'page'
React          = require 'react'
I18n           = require './utils/I18n'
ApiUtils       = require './utils/ApiUtils'
PlannerActions = require './actions/PlannerActions'
ErrorPage      = React.createFactory require './components/ErrorPage'

{POLL_INTERVAL} = require './constants/PlannerConstants'

# Initializers
require './initializers/bootstrap'

I18n.init()
ApiUtils.init()


Page '/', ->
  # TODO init this as an action. School and User stores
  ApiUtils.initSchool (err, school)->
    if err?
      React.render(
        ErrorPage error: err
        document.body
      )
    else
      PlannerActions.initSchedules()
      # TODO Tests
      # OK because POLL_INTERVAL will always be sufficiently big
      setInterval PlannerActions.updateSchedules, POLL_INTERVAL

      PlannerApp = React.createFactory require './components/PlannerApp'
      React.render(
        PlannerApp ui: school.appUi
        document.body
      )


Page '/schedules/:scheduleId', (ctx)->
  SingleSchedulePage = React.createFactory(
    require './components/SingleSchedulePage'
  )

  React.render(
    SingleSchedulePage scheduleId: ctx.params.scheduleId
    document.body
  )


Page '*', ->
  React.render(
    ErrorPage({})
    document.body
  )

Page()

