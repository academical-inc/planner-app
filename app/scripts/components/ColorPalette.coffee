
React  = require 'React'
colors = require('../constants/PlannerConstants').colors
R      = React.DOM


ColorPalette = React.createClass(

  render: ->
    R.div className: "pla-color-palette collapse", id: @props.id,
      (R.div(
        key: color
        className: "color"
        style: {backgroundColor: color}
        onClick: @props.handleColorSelect
        "data-color": color
       ) for color in colors)

)

module.exports = ColorPalette
