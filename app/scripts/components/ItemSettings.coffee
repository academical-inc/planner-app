
React        = require 'react'
I18nMixin    = require '../mixins/I18nMixin'
ColorPalette = React.createFactory require '../components/ColorPalette'
R            = React.DOM


ItemSettings = React.createClass(

  mixins: [I18nMixin]

  render: ->
    R.div className: 'pla-item-settings',
      R.div null,
        ColorPalette
          item: @props.item
          handleColorSelect: @props.handleColorSelect
      R.div null,
        R.span null,
          @props.deleteIcon
          R.span
            className: "delete-msg"
            onClick: @props.handleItemDelete
            @t("sidebar.item.delete")

)

module.exports = ItemSettings
