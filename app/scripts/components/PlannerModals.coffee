
React             = require 'react'
I18nMixin         = require '../mixins/I18nMixin'
Modal             = React.createFactory require './Modal'
PersonalEventForm = React.createFactory require './PersonalEventForm'
R                 = React.DOM

PlannerModals = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: "pla-modals",
      Modal id: "pla-personal-event-modal", header: @t("eventForm.header"),
        PersonalEventForm({})

)

module.exports = PlannerModals
