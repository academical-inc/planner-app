
React           = require 'react'
PlannerBody     = React.createFactory require './PlannerBody'
SlideMenuHandle = React.createFactory require './SlideMenuHandle'
PlannerModals   = React.createFactory require './PlannerModals'
PlannerHeader   = React.createFactory require './PlannerHeader'
R               = React.DOM

PlannerApp = React.createClass(

  render: ->
    R.div className: 'pla-content container-fluid',
      SlideMenuHandle({})
      PlannerHeader({})
      PlannerBody ui: @props.ui
      PlannerModals({})

)

module.exports = PlannerApp
