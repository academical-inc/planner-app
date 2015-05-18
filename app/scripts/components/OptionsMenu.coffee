
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
StoreMixin     = require '../mixins/StoreMixin'
ScheduleStore  = require '../stores/ScheduleStore'
ExportStore    = require '../stores/ExportStore'
ExportUtils    = require '../utils/ExportUtils'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
Dropdown       = React.createFactory require './Dropdown'
OptionsItem    = React.createFactory require './OptionsItem'
R              = React.DOM


# TODO Test
OptionsMenu = React.createClass(

  mixins: [I18nMixin, IconMixin, StoreMixin(ExportStore)]

  getItems: ->
    [
      {
        header: "General:"
        items: [
          {id: "opt1", val: @t("options.summary"), icon: @icon "book"}
          {id: "opt2", val: @t("options.duplicate"), icon: @icon "copy"}
          {id: "opt3", val: @t("options.share"), icon: @icon "share-alt"}
        ]
      }
      {
        header: "Export:"
        items: [
          {id: "opt4", val: @t("options.calendar"), icon: @icon "calendar"}
          {id: "opt5", val: @t("options.image"), icon: @icon "camera-retro"}
        ]
      }
    ]

  onChange: ->
    ExportUtils.downloadImage ScheduleStore.current().name, ExportStore.canvas()

  openSummary: ->
    PlannerActions.openSummaryDialog()

  duplicateSchedule: ->
    PlannerActions.duplicateSchedule()

  exportImage: ->
    PlannerActions.exportToImage $(UiConstants.selectors.WEEK_CALENDAR)[0]

  handleItemSelected: (item)->
    switch item.id
      when "opt1" then @openSummary()
      when "opt2" then @duplicateSchedule()
      when "opt5" then @exportImage()

  render: ->
    Dropdown(
      className: 'pla-options-menu'
      rootTag: @props.rootTag
      title: @icon "gears"
      itemType: OptionsItem
      items: @getItems()
      handleItemSelected: @handleItemSelected
    )

)

module.exports = OptionsMenu

