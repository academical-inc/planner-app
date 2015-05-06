
$             = require 'jquery'
React         = require 'react'
I18n          = require '../utils/I18n'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

module.exports =

  renderButtons: (btns)->
    defaults =
      accept:
        show: true
        type: "success"
        text: I18n.t "dialogs.save"
      cancel:
        show: true
        type: "danger"
        text: I18n.t "dialogs.cancel"
    btns = $.extend true, {}, defaults, btns

    btnAcceptProps =
      className: "btn btn-#{btns.accept.type}"
      key: "accept"
      type: "submit"
    if btns.accept.form?
      btnAcceptProps.form = btns.accept.form
    else
      btnAcceptProps["data-dismiss"] = "modal"
      btnAcceptProps.onClick = btns.accept.handler

    btnCancelProps =
      className: "btn btn-#{btns.cancel.type}"
      key: "cancel"
      type: "button"
      onClick: btns.cancel.handler
      "data-dismiss": "modal"

    btnsRes = []
    if btns.cancel.show is true
      btnsRes.push R.button(btnCancelProps, btns.cancel.text)
    if btns.accept.show is true
      btnsRes.push R.button(btnAcceptProps, btns.accept.text)

    btnsRes

  show: ->
    $(@getDOMNode()).modal "show"

  hide: ->
    $(@getDOMNode()).modal "hide"

  renderModal: (modalId, header, body, buttons)->
    buttons = @renderButtons buttons
    labelId = "#{@props.id}-label"

    R.div(
      {
        className: "modal fade"
        id: modalId
        tabIndex: "-1"
        role: "dialog"
        "aria-labelledby": labelId
        "aria-hidden": true
      },
      R.div className: "modal-dialog",
        R.div className: "modal-content #{modalId}",
          R.div className: "modal-header",
            R.button className: "close", "data-dismiss": "modal",
              R.span "aria-hidden": true, UiConstants.htmlEntities.TIMES
              R.span className: "sr-only", "Close"
            R.h4 className: "modal-title", id: labelId, header
          R.div className: "modal-body", body
          R.div className: "modal-footer", buttons
    )

