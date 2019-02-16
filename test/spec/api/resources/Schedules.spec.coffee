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

H          = require '../../../SpecHelper'
Schedules  = require '../../../../app/scripts/api/resources/Schedules'
Academical = require '../../../../app/scripts/api/Academical'


describe 'Schedules', ->

  beforeEach ->
    @api       = new Academical {}
    @schedules = new Schedules @api
    @cb        = H.spy "cb"
    H.ajax.install()

  afterEach ->
    H.ajax.uninstall()


  describe 'create', ->

    it 'sends the correct request', ->
      data = {name: "S1", studentId: "12345"}
      @schedules.create data, @cb
      H.ajax.assertRequest(
        "post"
        @api.get "host"
        @api.get "protocol"
        "/schedules"
        data: data
      )


  describe 'update', ->

    it 'sends the correct request', ->
      data = {name: "S3", studentId: "12345"}
      @schedules.update "sch123", data, @cb
      H.ajax.assertRequest(
        "put"
        @api.get "host"
        @api.get "protocol"
        "/schedules/sch123"
        data: data
      )


  describe 'del', ->

    it 'sends the correct request', ->
      @schedules.del "sch123", @cb
      H.ajax.assertRequest(
        "delete"
        @api.get "host"
        @api.get "protocol"
        "/schedules/sch123"
      )

