
React         = require 'react'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


ColorPalette = React.createClass(

  renderColor: (color)->
    handleColorSelect = @props.handleColorSelect
    R.div
      key: color
      className: "color"
      style: {backgroundColor: color}
      "data-color": color
      onClick: handleColorSelect.bind null, color if handleColorSelect?

  render: ->
    count = UiConstants.colors.length
    R.div className: "pla-color-palette",
      R.div className: "color-row",
        (@renderColor color for color in UiConstants.colors[0...count/2])
      R.div className: "color-row",
        (@renderColor color for color in UiConstants.colors[count/2...count])

)

module.exports = ColorPalette
