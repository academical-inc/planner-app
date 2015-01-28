
React             = require 'react'
I18n              = require './utils/I18n'
ApiUtils          = require './utils/ApiUtils'
ErrorPage         = React.createFactory require './components/ErrorPage'
PlannerApp        = React.createFactory require './components/PlannerApp'

I18n.init()

React.render(
  PlannerApp({})
  document.body
)


