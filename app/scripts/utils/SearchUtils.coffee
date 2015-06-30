
$           = require 'jquery'
Bloodhound  = require 'bloodhound'
Env         = require '../Env'
SchoolStore = require '../stores/SchoolStore'
UserStore   = require '../stores/UserStore'
SearchStore = require '../stores/SearchStore'

# Private
# TODO Remove Bloodhound, may be making it slow
_q = ""

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

prepareRequest = (query, settings)->
  {nickname, terms} = SchoolStore.school()
  authToken         = UserStore.authToken()
  params =
    q: query
    school: nickname
    term: terms[0].name
    filters: JSON.stringify SearchStore.filters()
    camelize: true

  settings.url    += "?#{$.param(params)}"
  settings.headers = "Authorization": "Bearer #{authToken}" if authToken?
  _q = query
  settings

transform = (response)->
  response.data

sync  = (query, cb)->
  (results)->

async = (query, cb)->
  (results)->
    if _q is query
      cb null, (if results.length > 0 then results else [null])


_engine = new Bloodhound
  remote:
    url: "#{Env.API_PROTOCOL}://#{Env.API_HOST}/sections/search"
    prepare: prepareRequest
    transform: transform
  identify: identify
  datumTokenizer: datumTokenizer
  queryTokenizer: Bloodhound.tokenizers.whitespace

# TODO Test
class SearchUtils

  @search: (query, cb)->
    _engine.search query, sync(query, cb), async(query, cb)

  @clearSearch: ->
    _q = null

module.exports = SearchUtils
