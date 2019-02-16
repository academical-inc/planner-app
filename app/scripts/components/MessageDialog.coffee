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
