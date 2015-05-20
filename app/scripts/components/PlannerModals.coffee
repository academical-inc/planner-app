
React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
EventForm     = React.createFactory require './EventForm'
SummaryDialog = React.createFactory require './SummaryDialog'
ShareDialog   = React.createFactory require './ShareDialog'
ErrorDialog   = React.createFactory require './ErrorDialog'
R             = React.DOM

PlannerModals = React.createClass(

  mixins: [I18nMixin]

  render: ->
    ui = @props.ui

    R.div className: "pla-modals",
      EventForm({})
      SummaryDialog fields: ui.summaryFields
      ShareDialog({})
      ErrorDialog({})

)

module.exports = PlannerModals
