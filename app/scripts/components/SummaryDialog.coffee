
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
