
React    = require 'react'
Dropdown = React.createFactory require './Dropdown'
R        = React.DOM

OptionsList = React.createClass(

  icon: (icon)->
    R.i className: "fa fa-#{icon} fa-fw"

  getItems: ->
    [
      {
        header: "General:"
        items: [
          {key: "opt1", val: "Summary", icon: @icon "book"}
          {key: "opt2", val: "Change name", icon: @icon "pencil"}
          {key: "opt3", val: "Duplicate", icon: @icon "copy"}
          {key: "opt4", val: "Share your schedule", icon: @icon "share-alt"}
          {key: "opt5", val: "Delete", icon: @icon "trash"}
        ]
      }
      {
        header: "Export:"
        items: [
          {key: "opt6", val: "Calendar", icon: @icon "calendar"}
          {key: "opt7", val: "Image", icon: @icon "camera-retro"}
        ]
      }
    ]

  render: ->
    Dropdown(
      className: 'pla-options-list'
      rootTag: @props.rootTag
      title: @icon "gears"
      items: @getItems()
    )

)

module.exports = OptionsList

