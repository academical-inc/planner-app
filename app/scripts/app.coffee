
React      = require 'react'
I18n       = require './utils/I18n'
PlannerApp = React.createFactory require './components/PlannerApp'

I18n.init()
I18n.setLocale "en"

React.render(
  PlannerApp({})
  document.body
)
