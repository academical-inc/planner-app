#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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

  componentDidMount: ->
    $(@getDOMNode()).on 'shown.bs.modal', @onShown if @onShown?

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
      R.div className: "modal-dialog pla-modal #{modalId}",
        R.div className: "modal-content",
          R.div className: "modal-header",
            R.button className: "close", "data-dismiss": "modal",
              R.img src: '/images/popup_quit_icon.png'
              R.span className: "sr-only", "Close"
            R.h4 className: "modal-title", id: labelId, header
          R.div className: "modal-body", body
          R.div className: "modal-footer", buttons
    )

