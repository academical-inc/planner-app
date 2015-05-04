
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
EventForm     = React.createFactory require './EventForm'
ErrorDialog   = React.createFactory require './ErrorDialog'
SummaryDialog = React.createFactory require './SummaryDialog'
R             = React.DOM

PlannerModals = React.createClass(

  mixins: [I18nMixin]

  render: ->
    ui = @props.ui

    R.div className: "pla-modals",
      EventForm({})
      SummaryDialog fields: ui.summaryFields
      ErrorDialog({})

)

module.exports = PlannerModals
