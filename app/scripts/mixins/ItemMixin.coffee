
$            = require 'jquery'
React        = require 'react'
Popover      = React.createFactory require '../components/Popover'
ItemSettings = React.createFactory require '../components/ItemSettings'
R            = React.DOM


module.exports =

  componentWillMount: ->
    throw new Error "Must include IconMixin" if not @icon?

  handleItemDelete: (e)->
    e.preventDefault()
    e.stopPropagation()
    @props.handleItemDelete @props.item

  renderDeleteIcon: ->
    if @props.item.del is true
      @renderSpinner()
    else
      @imgIcon "/images/delete_icon.png",
        onClick: @handleItemDelete
        className: "delete-icon"

  renderSettingsIcon: ->
    if @props.item.del is true
      @renderSpinner()
    else
      @imgIcon '/images/settings_icon.png',

  renderSettings: ->
    Popover
      content: ItemSettings
        handleColorSelect: @handleColorSelect
        handleItemDelete: @handleItemDelete
        deleteIcon: @renderDeleteIcon()
      placement: 'bottom'
      trigger: 'click'
      R.span className: 'settings-icon',
        @renderSettingsIcon()
