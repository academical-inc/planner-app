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

H       = require '../../SpecHelper'
request = require '../../../app/scripts/api/request'


describe 'request', ->

  beforeEach ->
    H.ajax.install()
    @cb = H.spy "callback"
    @data = {d1: "d1", d2: "d2"}

  afterEach ->
    H.ajax.uninstall()

  it 'sends correct query string when GETing', ->
    req = request "get", "https://host.com", @cb, data: @data
    expect(req._query[0]).toEqual "d1=d1&d2=d2"
    expect(req._data).toBeUndefined()

  it 'sends correct data in body otherwise', ->
    req = request "post", "https://host.com", @cb, data: @data
    expect(req._query.length).toEqual 0
    expect(req._data).toEqual @data

  it 'calls the callback on success', ->
    req = request "post", "https://host.com", @cb
    H.ajax.succeed success: true
    expect(@cb).toHaveBeenCalled()

  it 'calls the callback on failure', ->
    req = request "post", "https://host.com", @cb
    H.ajax.fail()
    expect(@cb).toHaveBeenCalled()

