
React             = require 'react'
PlannerHeader     = require './PlannerHeader.react'
PlannerBody       = require './PlannerBody.react'
SlideMenuHandle   = require './SlideMenuHandle.react'
R                 = React.DOM

PlannerApp = React.createClass(

  render: ->
    R.div className: 'pla-content container-fluid',
      SlideMenuHandle({})
      PlannerHeader({})
      PlannerBody({})

)

module.exports = PlannerApp
