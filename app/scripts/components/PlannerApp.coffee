
React           = require 'react'
PlannerBody     = React.createFactory require './PlannerBody'
SlideMenuHandle = React.createFactory require './SlideMenuHandle'
PlannerModals   = React.createFactory require './PlannerModals'
PlannerSideBar = React.createFactory require './PlannerSideBar'
R               = React.DOM

PlannerApp = React.createClass(

  render: ->
    R.div className: 'pla-content container-fluid',
      SlideMenuHandle({})
      PlannerSideBar({})
      PlannerBody({})
      PlannerModals({})

)

module.exports = PlannerApp
