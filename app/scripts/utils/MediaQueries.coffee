
UIConstants = require('../constants/PlannerConstants').ui


class MediaQueries

  @_buildMinQuery: (width)->
    "(min-width: #{width}px)"

  @matchesMDAndUp: ->
    window.matchMedia(@_buildMinQuery(UIConstants.media.SCREEN_MD_MIN)).matches


module.exports = MediaQueries
