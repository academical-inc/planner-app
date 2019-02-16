#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

$                  = require 'jquery'
Bloodhound         = require 'bloodhound'
Env                = require '../Env'
Utils              = require '../utils/Utils'
SchoolStore        = require '../stores/SchoolStore'
UserStore          = require '../stores/UserStore'
SearchFiltersStore = require '../stores/SearchFiltersStore'

# Private
# TODO Remove Bloodhound, may be making it slow
# TODO Unify all requests in ApiUtils
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
    filters: JSON.stringify SearchFiltersStore.filters()

  settings.url    += "?#{$.param(params)}"
  settings.headers = "Authorization": "Bearer #{authToken}" if authToken?
  _q = query
  settings

transform = (response)->
  Utils.camelizedKeys response.data

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
    if query?
      _engine.search query, sync(query, cb), async(query, cb)
    else
      cb([])

  @clearSearch: ->
    _q = null

module.exports = SearchUtils
