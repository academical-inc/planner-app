
React             = require 'react'
Modal             = require './Modal'
PersonalEventForm = require './PersonalEventForm'
R                 = React.DOM

PlannerModals = React.createClass(

  render: ->
    R.div className: "pla-modals",
      Modal id: "pla-personal-event-modal", header: "Add a personal event",
        PersonalEventForm({})

)

module.exports = PlannerModals
