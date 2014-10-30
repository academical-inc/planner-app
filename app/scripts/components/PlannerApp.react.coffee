
$                 = require 'jquery'
React             = require 'react'
PlannerHeader     = require './PlannerHeader.react'
PlannerBody       = require './PlannerBody.react'
SlideMenuHandle   = require './SlideMenuHandle.react'
C                 = require '../constants/PlannerConstants'
R                 = React.DOM

PlannerApp = React.createClass(

  render: ->
    R.div className: 'pla-content container-fluid',
      SlideMenuHandle(
        scheduleListSelector: C.selectors.SCHEDULE_LIST,
        $: $
      )
      PlannerHeader($: $)
      PlannerBody($: $)

)

module.exports = PlannerApp
