
React              = require 'react'
ModalMixin         = require '../mixins/ModalMixin'
I18nMixin          = require '../mixins/I18nMixin'
StoreMixin         = require '../mixins/StoreMixin'
SummaryDialogStore = require '../stores/SummaryDialogStore'
{UiConstants}      = require '../constants/PlannerConstants'
R                  = React.DOM


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
        @state.summary.map (sectionVals)->
          R.tr null,
            sectionVals.map (val)->
              R.td null, val


  render: ->
    fields = @props.fields
    @renderModal(
      UiConstants.ids.SUMMARY_MODAL
      @t "summaryDialog.header"
      @renderBody fields
      accept: text: @t "summaryDialog.ok"
      cancel: show: false
    )

)

module.exports = SummaryDialog
