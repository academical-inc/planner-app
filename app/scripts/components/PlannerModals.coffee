
React             = require 'react'
I18nMixin         = require '../mixins/I18nMixin'
PersonalEventForm = React.createFactory require './PersonalEventForm'
ErrorDialog       = React.createFactory require './ErrorDialog'
R                 = React.DOM

PlannerModals = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: "pla-modals",
      PersonalEventForm({})
      ErrorDialog({})

)

module.exports = PlannerModals
