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

superagent = require 'superagent'


module.exports = (method, url, cb, {data, headers, timeout}={})->
  data    ?= {}
  headers ?= {}
  timeout ?= 0

  req = superagent method, url
    .set headers
    .timeout timeout

  (if method.toLowerCase() == "get"
    req.query data
  else
    req.send data
  ).end cb

