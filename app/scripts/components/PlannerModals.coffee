
React             = require 'react'
Modal             = React.createFactory require './Modal'
PersonalEventForm = React.createFactory require './PersonalEventForm'
R                 = React.DOM

PlannerModals = React.createClass(

  render: ->
    R.div className: "pla-modals",
      Modal id: "pla-personal-event-modal", header: "Add a personal event",
        PersonalEventForm({})

)

module.exports = PlannerModals
