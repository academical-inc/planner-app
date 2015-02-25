
Page           = require 'page'
React          = require 'react'
I18n           = require './utils/I18n'
ApiUtils       = require './utils/ApiUtils'
PlannerActions = require './actions/PlannerActions'
ErrorPage  = React.createFactory require './components/ErrorPage'

I18n.init()
ApiUtils.init()


Page '/', ->
  ApiUtils.initSchool (err, school)->
    if err?
      React.render(
        ErrorPage error: err
        document.body
      )
    else
      PlannerActions.initSchedules()

      PlannerApp = React.createFactory require './components/PlannerApp'
      React.render(
        PlannerApp({})
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

