$             = require 'jquery'
React         = require 'react'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


MessageDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin]

  renderBody: ->
    R.div className: "pla-message-dialog",
      R.div className: "row", @props.message.map (msg, i)->
        R.p key: "p-#{i}", dangerouslySetInnerHTML: {__html: msg}

  render: ->
    @renderModal(
      UiConstants.ids.MESSAGE_MODAL
      @t "messageDialog.header"
      @renderBody()
      accept: show: false
      cancel: text: @t "dialogs.ok"
    )

)

module.exports = MessageDialog
