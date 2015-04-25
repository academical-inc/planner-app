
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

identify = (section)->
  section.id

_engine = new Bloodhound
  prefetch:
    url: Env.SECTIONS_URL
    ttl: 1
  identify:    identify
  datumTokenizer: datumTokenizer
  queryTokenizer: Bloodhound.tokenizers.whitespace


class SearchStore extends Store

  query: (query, cb)->
    _engine.search query, cb

  dispatchCallback: (payload)->
    action = payload.action


module.exports = new SearchStore
