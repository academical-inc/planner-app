
React      = require 'react'
PlannerApp = React.createFactory require './components/PlannerApp'

React.render(
  PlannerApp({}),
  document.body
)
