
React         = require 'react'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


ShareDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin, IconMixin]

  getInitialState: ->
    link: "https://bit.ly"

  renderBody: ->
    R.form className: 'pla-share-dialog',
      R.div className: "form-group",
        R.label htmlFor: "copyInput", @t("shareDialog.linkMsg")
        R.div className: "input-group",
          R.input
            className: "form-control"
            id: "copyInput"
            type: "text"
            value: @state.link
            autoComplete: "off"
            # readOnly: true
          R.button
            className: "btn btn-success"
            onClick: @copy
            @t("shareDialog.copy")
      R.div className: "form-group",
        R.label null, @t("shareDialog.socialMsg")
        R.div null,
          @imgIcon "/images/fb_icon.png"
          @imgIcon "/images/tw_icon.png"

  render: ->
    @renderModal(
      UiConstants.ids.SHARE_MODAL
      @t "shareDialog.header"
      @renderBody()
      accept: show: false
      cancel: show: false
    )

)

module.exports = ShareDialog
