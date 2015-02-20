
React         = require 'react'
$             = require 'jquery'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
ErrorStore    = require '../stores/ErrorStore'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


ErrorDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin]

  onChange: ->
    @setState error: ErrorStore.getError()
    $(UiConstants.selectors.ERROR_MODAL).modal "show"

  getInitialState: ->
    error: "Error"

  componentDidMount: ->
    ErrorStore.addChangeListener @onChange

  componentWillUnmount: ->
    ErrorStore.removeChangeListener @onChange

  renderBody: ->
    R.div className: "pla-error-dialog", @state.error

  render: ->
    @renderModal(
      UiConstants.ids.ERROR_MODAL
      @t "errorDialog.header"
      @renderBody()
    )

)

module.exports = ErrorDialog
