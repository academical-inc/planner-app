
React           = require 'react'
PlannerHeader   = React.createFactory require './PlannerHeader'
PlannerBody     = React.createFactory require './PlannerBody'
SlideMenuHandle = React.createFactory require './SlideMenuHandle'
PlannerModals   = React.createFactory require './PlannerModals'
R               = React.DOM

PlannerApp = React.createClass(

  render: ->
    R.div className: 'pla-content container-fluid',
      SlideMenuHandle({})
      PlannerHeader({})
      PlannerBody({})
      PlannerModals({})

)

module.exports = PlannerApp
