
React             = require 'react'
PlannerHeader     = require './PlannerHeader.react'
PlannerBody       = require './PlannerBody.react'
R                 = React.DOM

PlannerApp = React.createClass(

  render: ->
    R.div className: 'pla-content',
      PlannerHeader({})
      PlannerBody({})

)

module.exports = PlannerApp
