
React       = require 'React'
UIConstants = require('../constants/PlannerConstants').ui
R           = React.DOM


ColorPalette = React.createClass(

  render: ->
    colors = UIConstants.colors

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
