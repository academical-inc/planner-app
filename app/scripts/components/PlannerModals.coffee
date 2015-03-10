
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
EventForm   = React.createFactory require './EventForm'
ErrorDialog = React.createFactory require './ErrorDialog'
R           = React.DOM

PlannerModals = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: "pla-modals",
      EventForm({})
      ErrorDialog({})

)

module.exports = PlannerModals
