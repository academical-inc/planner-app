
Bloodhound    = require 'bloodhound'
Env           = require '../Env'

# Private
datumTokenizer = (section)->
  teacherNames = section.teacherNames.map (name)->
    Bloodhound.tokenizers.whitespace name

  if teacherNames.length > 0
    teacherNames = teacherNames.reduce (a1, a2) -> a1.concat(a2)

  [].concat(
    Bloodhound.tokenizers.whitespace section.courseName
    [section.courseCode]
    Bloodhound.tokenizers.whitespace section.departments[0].name
    [section.sectionId]
    teacherNames
  )

identify = (section)->
  section.id

_engine = new Bloodhound
  prefetch:
    url: Env.SECTIONS_URL
    ttl: 1
  identify:    identify
  datumTokenizer: datumTokenizer
  queryTokenizer: Bloodhound.tokenizers.whitespace


# TODO Test
class SearchUtils

  @search: (query, cb)->
    _engine.search query, (results)->
      cb null, (if results.length > 0 then results else [null])


module.exports = SearchUtils
