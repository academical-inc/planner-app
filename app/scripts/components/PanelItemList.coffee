
React = require 'react'
R     = React.DOM

PanelItemList = React.createClass(

  render: ->
    R.div className: "pla-panel-item-list",
      R.h5 className: "list-header", @props.header
      R.div(
        {
          className: "panel-group"
          role: "tablist"
          "aria-multiselectable": "true"
        },
        for item in @props.items
          @props.itemType
            key: item.id
            item: item
            color: item.color or @props.colors[item.id]
            handleItemDelete: @props.handleItemDelete
      )
      if @props.handleItemAdd?
        R.div className: "add-item-bar",
          R.button(
            {
              type: "button"
              className: "btn btn-info btn-circle"
              onClick: @props.handleItemAdd
            },
            R.i className: "fa fa-plus"
          )
)

module.exports = PanelItemList

