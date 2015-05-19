
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
ScheduleStore  = require '../stores/ScheduleStore'
# TODO Revisit this design. Must require even if not using
ExportStore    = require '../stores/ExportStore'
PlannerActions = require '../actions/PlannerActions'
{UiConstants}  = require '../constants/PlannerConstants'
Dropdown       = React.createFactory require './Dropdown'
OptionsItem    = React.createFactory require './OptionsItem'
R              = React.DOM


# TODO Test
OptionsMenu = React.createClass(

  mixins: [I18nMixin, IconMixin]

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

  handleItemSelected: (item)->
    switch item.id
      when "opt1" then @openSummaryDialog()
      when "opt2" then @duplicateSchedule()
      when "opt4" then @exportICS()
      when "opt5" then @exportImage()

  openSummaryDialog: ->
    PlannerActions.openSummaryDialog()

  duplicateSchedule: ->
    PlannerActions.duplicateSchedule()

  exportICS: ->
    PlannerActions.exportToICS ScheduleStore.current().id

  exportImage: ->
    PlannerActions.exportToImage $(UiConstants.selectors.WEEK_CALENDAR)[0]

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

