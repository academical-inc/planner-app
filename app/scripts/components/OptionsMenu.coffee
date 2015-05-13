
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
IconMixin      = require '../mixins/IconMixin'
PlannerActions = require '../actions/PlannerActions'
Dropdown       = React.createFactory require './Dropdown'
OptionsItem    = React.createFactory require './OptionsItem'
R              = React.DOM


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

  openSummary: ->
    PlannerActions.openSummaryDialog()

  duplicateSchedule: ->
    PlannerActions.duplicateSchedule()

  handleItemSelected: (item)->
    switch item.id
      when "opt1" then @openSummary()
      when "opt2" then @duplicateSchedule()

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

