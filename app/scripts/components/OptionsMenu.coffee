
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
IconMixin   = require '../mixins/IconMixin'
Dropdown    = React.createFactory require './Dropdown'
OptionsItem = React.createFactory require './OptionsItem'
R           = React.DOM


OptionsMenu = React.createClass(

  mixins: [I18nMixin, IconMixin]

  getItems: ->
    [
      {
        header: "General:"
        items: [
          {id: "opt1", val: @t("options.summary"), icon: @icon "book"}
          {id: "opt2", val: @t("options.changeName"), icon: @icon "pencil"}
          {id: "opt3", val: @t("options.duplicate"), icon: @icon "copy"}
          {id: "opt4", val: @t("options.share"), icon: @icon "share-alt"}
        ]
      }
      {
        header: "Export:"
        items: [
          {id: "opt5", val: @t("options.calendar"), icon: @icon "calendar"}
          {id: "opt6", val: @t("options.image"), icon: @icon "camera-retro"}
        ]
      }
    ]

  render: ->
    Dropdown(
      className: 'pla-options-list'
      rootTag: @props.rootTag
      title: @icon "gears"
      itemType: OptionsItem
      items: @getItems()
    )

)

module.exports = OptionsMenu

