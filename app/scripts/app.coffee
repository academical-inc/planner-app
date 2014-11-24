
# Load and use polyfill for ECMA-402.
if not global.Intl?
  global.Intl = require('intl')
I18n       = require '../locales/i18n.json'

React      = require 'react'
PlannerApp = React.createFactory require './components/PlannerApp'


React.render(
  PlannerApp(locales: ["en"], messages: I18n.messages["en"])
  document.body
)
