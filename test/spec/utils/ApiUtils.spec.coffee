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

Moment   = require 'moment'
H        = require '../../SpecHelper'
ApiUtils = require '../../../app/scripts/utils/ApiUtils'


describe 'ApiUtils', ->

  beforeEach ->
    @api = H.spyObj "s2", ["setHost", "data"]
    @_   = H.spyObj "_",
      setTime: (a1,a2)->a1
      format: (a1)->a1
      utc: (a1)->a1
    @terms = [{startDate: "2015-01-01", endDate: "2015-05-01"}]
    @global = H.rewire ApiUtils,
      "Env.API_HOST": "API_HOST"
      "Env.API_PROTOCOL": "API_PROTOCOL"
      Academical: H.spy "s1", retVal: @api
      "_api": @api

  afterEach ->
    @global()

  describe '.init', ->

    it 'inits correctly', ->
      ApiUtils.init()
      expect(@api.setHost).toHaveBeenCalledWith "API_HOST", "API_PROTOCOL"
