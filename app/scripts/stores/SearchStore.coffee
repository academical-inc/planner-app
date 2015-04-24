
Bloodhound    = require 'bloodhound'
Env           = require '../Env'
Store         = require './Store'
{ActionTypes} = require '../constants/PlannerConstants'
{UiConstants} = require '../constants/PlannerConstants'


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

dupDetector = (section1, section2)->
  section1.sectionId == section2.sectionId

_engine = new Bloodhound
  name: 'sections',
  prefetch:
    url: Env.SECTIONS_URL
    ttl: 1
  limit: UiConstants.search.maxResults
  dupDetector:    dupDetector
  datumTokenizer: datumTokenizer
  queryTokenizer: Bloodhound.tokenizers.whitespace

_engine.initialize()


class SearchStore extends Store

  query: (query, cb)->
    _engine.get query, cb

  dispatchCallback: (payload)->
    action = payload.action


module.exports = new SearchStore
