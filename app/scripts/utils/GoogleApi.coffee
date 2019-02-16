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

Request = require '../api/Request'
API_KEY = require('../Env').GOOGLE_API_KEY
{GoogleApiConstants: {
  API_HOST
}} = require '../constants/PlannerConstants'


class GoogleApi

  @shorten: (longUrl, cb)->
    Request(
      "post"
      "#{API_HOST}/urlshortener/v1/url?key=#{API_KEY}"
      (err, response)->
        cb err, response.body.id
      headers: {"Content-Type": "application/json"}
      data: {longUrl: longUrl}
    )

module.exports = GoogleApi
