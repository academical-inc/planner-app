
React        = require 'react'
I18n         = require './utils/I18n'
ApiUtils     = require './utils/ApiUtils'
SchoolStore  = require './stores/SchoolStore'
StudentStore = require './stores/StudentStore'

require './boot'

SchoolStore.init ApiUtils.currentSchool(),
  success: (school)->
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
