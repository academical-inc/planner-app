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

class Env

  @APP_ENV:          process.env.APP_ENV
  @SECTIONS_URL:     process.env.SECTIONS_URL
  @API_HOST:         process.env.API_HOST
  @API_PROTOCOL:     process.env.API_PROTOCOL
  @AUTH0_DOMAIN:     process.env.AUTH0_DOMAIN
  @AUTH0_CLIENT_ID:  process.env.AUTH0_CLIENT_ID
  @GOOGLE_API_KEY:   process.env.GOOGLE_API_KEY
  @FB_APP_ID:        process.env.FB_APP_ID
  @BUGSNAG_API_KEY:  process.env.BUGSNAG_API_KEY
  @SCHOOL:           process.env.SCHOOL
  @CLOSED:           process.env.CLOSED
  @ANNOUNCE:         process.env.ANNOUNCE


module.exports = Env
