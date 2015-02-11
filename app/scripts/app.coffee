
Page       = require 'page'
React      = require 'react'
I18n       = require './utils/I18n'
ApiUtils   = require './utils/ApiUtils'

I18n.init()


Page '/', ->
  PlannerApp = React.createFactory require './components/PlannerApp'

  React.render(
    PlannerApp({})
    document.body
  )


Page '/schedules/:schedule_id', ->
  SingleSchedulePage = React.createFactory(
    require './components/SingleSchedulePage'
  )

  React.render(
    SingleSchedulePage({})
    document.body
  )


Page '*', ->
  ErrorPage  = React.createFactory require './components/ErrorPage'

  React.render(
    ErrorPage({})
    document.body
  )

Page()

