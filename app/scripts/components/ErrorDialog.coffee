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
