
{UiConstants} = require '../constants/PlannerConstants'

# Private
_colorIdx = 0

class ColorUtils

  @nextColor: ->
    colors = UiConstants.COLORS
    color = colors[_colorIdx]
    _colorIdx = (_colorIdx + 1) % colors.length
    color

module.exports = ColorUtils
