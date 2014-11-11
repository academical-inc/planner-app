
React  = require 'React'
R      = React.DOM


ColorPicker = React.createClass(

  render: ->
    R.a
      className: "pla-color-picker collapsed"
      href: "##{@props.colorPaletteId}"
      "data-toggle": "collapse"
      "aria-expanded": "false"
      "aria-controls": @props.colorPaletteId

)

module.exports = ColorPicker

