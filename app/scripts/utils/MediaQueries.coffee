
M = require('../constants/PlannerConstants').media

class MediaQueries

  @_buildMinQuery: (width)->
    "(min-width: #{width}px)"

  @matchesMDAndUp: ->
    window.matchMedia(@_buildMinQuery(M.SCREEN_MD_MIN)).matches


module.exports = MediaQueries
