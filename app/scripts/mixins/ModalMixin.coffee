
React         = require 'react'
$             = require 'jquery'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

module.exports =

  renderButtons: (btns)->
    defaults =
      accept:
        type: "success"
        text: "Save"
      cancel:
        type: "danger"
        text: "Cancel"
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

    [
      R.button btnCancelProps, btns.cancel.text
      R.button btnAcceptProps, btns.accept.text
    ]

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
        R.div className: "modal-content",
          R.div className: "modal-header",
            R.button className: "close", "data-dismiss": "modal",
              R.span "aria-hidden": true, UiConstants.htmlEntities.TIMES
              R.span className: "sr-only", "Close"
            R.h4 className: "modal-title", id: labelId, header
          R.div className: "modal-body", body
          R.div className: "modal-footer", buttons
    )

