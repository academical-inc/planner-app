
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
    @show()

  getInitialState: ->
    error: "Error!"

  componentDidMount: ->
    ErrorStore.addChangeListener @onChange

  componentWillUnmount: ->
    ErrorStore.removeChangeListener @onChange

  renderBody: ->
    R.div className: "pla-error-dialog",
      R.div className: "row",
        R.div className: "col-md-4",
          R.img src: "/images/error_icon.png"
        R.div className: "col-md-8",
          R.h4 null, @t("errors.header")
          if Array.isArray @state.error
            @state.error.map (er, i)->
              R.p key: "errLine-#{i}", er
          else
            R.p null, @state.error

  render: ->
    @renderModal(
      UiConstants.ids.ERROR_MODAL
      @t "errorDialog.header"
      @renderBody()
      accept: show: false
      cancel: text: @t "errorDialog.ok"
    )

)

module.exports = ErrorDialog
