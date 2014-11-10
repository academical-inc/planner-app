
React = require 'react'
$     = require 'jquery'
html  = require('../constants/PlannerConstants').htmlEntities
R     = React.DOM

Modal = React.createClass(

  renderButtons: (btns)->
    defaults =
      accept:
        type: "success"
        text: "Save"
        handler: ->
      cancel:
        type: "danger"
        text: "Cancel"
        handler: ->

    btns = $.extend true, {}, defaults, btns
    a = btns.accept
    c = btns.cancel

    [
      R.button className: "btn btn-#{c.type}", key: "cancel",\
        onClick: c.handler, "data-dismiss": "modal", c.text
      R.button className: "btn btn-#{a.type}", key: "accept",\
        onClick: a.handler, a.text
    ]

  render: ->
    buttonComponents = @renderButtons @props.buttons
    labelId = "#{@props.id}-label"

    R.div(
      {
        className: "modal fade"
        id: @props.id
        tabIndex: "-1"
        role: "dialog"
        "aria-labelledby": labelId
        "aria-hidden": true
      },
      R.div className: "modal-dialog",
        R.div className: "modal-content",
          R.div className: "modal-header",
            R.button className: "close", "data-dismiss": "modal",
              R.span "aria-hidden": true, html.TIMES
              R.span className: "sr-only", "Close"
            R.h4 className: "modal-title", id: labelId, @props.header
          R.div className: "modal-body", @props.children
          R.div className: "modal-footer", buttonComponents
    )
)

module.exports = Modal
