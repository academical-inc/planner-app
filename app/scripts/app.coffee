
I18n = require './utils/I18n'
I18n.init()

React      = require 'react'
PlannerApp = React.createFactory require './components/PlannerApp'

React.render(
  PlannerApp({})
  document.body
)
