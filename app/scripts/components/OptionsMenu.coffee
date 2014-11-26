
React       = require 'react'
Dropdown    = React.createFactory require './Dropdown'
OptionsItem = React.createFactory require './OptionsItem'
R           = React.DOM

OptionsMenu = React.createClass(

  icon: (icon)->
    R.i className: "fa fa-#{icon} fa-fw"

  getItems: ->
    [
      {
        header: "General:"
        items: [
          {id: "opt1", val: "Summary", icon: @icon "book"}
          {id: "opt2", val: "Change name", icon: @icon "pencil"}
          {id: "opt3", val: "Duplicate", icon: @icon "copy"}
          {id: "opt4", val: "Share your schedule", icon: @icon "share-alt"}
        ]
      }
      {
        header: "Export:"
        items: [
          {id: "opt5", val: "Calendar", icon: @icon "calendar"}
          {id: "opt6", val: "Image", icon: @icon "camera-retro"}
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

