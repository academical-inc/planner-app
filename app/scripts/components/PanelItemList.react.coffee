
React             = require 'react'
R                 = React.DOM

PanelItemList = React.createClass(

  getInitialState: ->
    items: @props.initialState

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
)

module.exports = PanelItemList




