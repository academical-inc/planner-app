
React             = require 'react'
R                 = React.DOM

PanelItemList = React.createClass(

  getInitialState: ->
    items: @props.initialState || []

  render: ->
    R.div className: "pla-panel-item-list",
      R.h5 className: "list-header", @props.header
      R.div(
        {
          className: "panel-group"
          role: "tablist"
          "aria-multiselectable": "true"
        },
        (@props.itemType(key: item.id, item: item) for item in @state.items)
      )
      if @props.handleItemAdd? or\
          (@props.itemAddDataToggle? and @props.itemAddDataTarget?)
        R.div className: "add-item-bar",
          R.button(
            {
              type: "button"
              className: "btn btn-info btn-circle"
              onClick: @props.handleItemAdd
              "data-toggle": @props.itemAddDataToggle
              "data-target": @props.itemAddDataTarget
            },
            R.i className: "fa fa-plus"
          )
)

module.exports = PanelItemList

