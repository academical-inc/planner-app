
$             = require 'jquery'
React         = require 'react'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
StoreMixin    = require '../mixins/StoreMixin'
AppErrorStore = require '../stores/AppErrorStore'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


ErrorDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin, StoreMixin(AppErrorStore)]

  onChange: ->
    @setState error: AppErrorStore.msg()
    @show()

  getInitialState: ->
    error: @props.error

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
      cancel: text: @t "dialogs.ok"
    )

)

module.exports = ErrorDialog
