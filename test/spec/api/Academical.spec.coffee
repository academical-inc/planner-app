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

H          = require '../../SpecHelper'
Academical = require '../../../app/scripts/api/Academical'


describe 'Academical', ->

  describe '#constructor', ->

    it 'inits resources correctly', ->
      Res1 = H.spy "Res1"
      Res2 = H.spy "Res2"
      resMap =
        Res1: Res1
        Res2: Res2
      api = new Academical(resMap)
      expect(Res1).toHaveBeenCalledWith api
      expect(Res2).toHaveBeenCalledWith api
      expect(api.res1).toEqual H.any(Res1)
      expect(api.res2).toEqual H.any(Res2)

    it 'assigns defaults correctly', ->
      api = new Academical {}
      expect(api.get("host")).toEqual Academical.DEFAULT_HOST
      expect(api.get("protocol")).toEqual Academical.DEFAULT_PROTOCOL
      expect(api.get("basePath")).toEqual Academical.DEFAULT_BASE_PATH
      expect(api.get("timeout")).toEqual Academical.DEFAULT_TIMEOUT
      expect(api.get("headers")).toEqual Academical.DEFAULT_HEADERS
