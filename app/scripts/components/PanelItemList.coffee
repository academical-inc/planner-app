
React = require 'react'
I18nMixin = require '../mixins/I18nMixin'
R     = React.DOM

PanelItemList = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: "pla-panel-item-list",
      R.h4 className: "list-header", @props.header
      R.h5 className: "list-subheader", @props.subheader if @props.subheader?
      R.div
        className: "panel-group"
        role: "tablist"
        "aria-multiselectable": "true"
        for item in @props.items
          @props.itemType
            key: item.id
            item: item
            color: item.color or @props.colors[item.id]
            handleItemDelete: @props.handleItemDelete
      if @props.handleItemAdd?
        R.div className: "add-item-bar",
          R.button
            type: "button"
            className: "btn btn-circle"
            onClick: @props.handleItemAdd
            R.img src: '/images/add_event_icon.png'
          R.span className: "add-item-header", @t("sidebar.createEvent")
)

module.exports = PanelItemList

