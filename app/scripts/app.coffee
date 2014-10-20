
React      = require 'react'
PlannerApp = require './components/PlannerApp.react'

$ ()->
  React.renderComponent(
    PlannerApp({}),
    document.getElementById("planner-app-content")
  )
