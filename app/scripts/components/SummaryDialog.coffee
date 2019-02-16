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

React              = require 'react'
ModalMixin         = require '../mixins/ModalMixin'
I18nMixin          = require '../mixins/I18nMixin'
StoreMixin         = require '../mixins/StoreMixin'
SummaryDialogStore = require '../stores/SummaryDialogStore'
{UiConstants}      = require '../constants/PlannerConstants'
R                  = React.DOM


# TODO Tests
SummaryDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin, StoreMixin(SummaryDialogStore)]

  getInitialState: ->
    summary: SummaryDialogStore.summary()

  onChange: ->
    @setState summary: SummaryDialogStore.summary()
    @show()

  renderBody: (fields)->
    R.table className: 'pla-summary-dialog table table-condensed table-striped',
      R.thead null,
        R.tr null,
          fields.map (f) -> R.th key: f.name, f.name
      R.tbody null,
        @state.summary.map (sectionVals, i)=>
          R.tr key: "summ-#{i}",
            sectionVals.map (val, j)=>
              R.td key: "summ-#{i}-#{j}", val or @t("empty")

  render: ->
    fields = @props.fields
    @renderModal(
      UiConstants.ids.SUMMARY_MODAL
      @t "summaryDialog.header"
      @renderBody fields
      accept: text: @t "dialogs.ok"
      cancel: show: false
    )

)

module.exports = SummaryDialog
