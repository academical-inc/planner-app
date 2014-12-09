
I18n        = require './utils/I18n'
SchoolStore = require './stores/SchoolStore'

require './boot'

SchoolStore.init
  success: (school)->
    console.log school
    I18n.init school.get("locale")

  error: ->
    console.warn "Could not find school"
    I18n.init()

  complete: ->
    React      = require 'react'
    PlannerApp = React.createFactory require './components/PlannerApp'

    React.render(
      PlannerApp appUi: SchoolStore.get("appUi")
      document.body
    )
