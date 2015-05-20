
React         = require 'react'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


ShareDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin]

  renderBody: ->
    R.div className: 'pla-share-dialog',
      "Share thee schedule!"

  render: ->
    @renderModal(
      UiConstants.ids.SHARE_MODAL
      @t "shareDialog.header"
      @renderBody()
      accept: text: @t "dialogs.ok"
      cancel: show: false
    )

)

module.exports = ShareDialog
