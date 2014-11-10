
React = require 'react'
Modal = require './Modal.react'
R     = React.DOM

PlannerModals = React.createClass(

  render: ->
    R.div className: "pla-modals",
      Modal id: "pla-personal-event-modal", header: "Add a personal event",
        R.div null, "stuff"

)

module.exports = PlannerModals
