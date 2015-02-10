
UiConstants = require('../constants/PlannerConstants').Ui


class MediaQueries

  @_buildMinQuery: (width)->
    "(min-width: #{width}px)"

  @matchesMDAndUp: ->
    window.matchMedia(@_buildMinQuery(UiConstants.media.SCREEN_MD_MIN)).matches


module.exports = MediaQueries
