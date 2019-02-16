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
Students   = require '../../../../app/scripts/api/resources/Students'
Academical = require '../../../../app/scripts/api/Academical'


describe 'Students', ->

  beforeEach ->
    @api      = new Academical {}
    @students = new Students @api
    @cb       = H.spy "cb"
    H.ajax.install()

  afterEach ->
    H.ajax.uninstall()


  describe '#retrieve', ->

    it 'sends the correct request', ->
      @students.retrieve "12345", @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/students/12345"
      )

    it 'sends the correct request when data provided', ->
      @students.retrieve "12345", {count: true}, @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/students/12345"
        data: {count: true}
      )


  describe '#listSchedules', ->

    it 'sends the correct request', ->
      @students.listSchedules "12345", @cb
      H.ajax.assertRequest(
        "get"
        @api.get "host"
        @api.get "protocol"
        "/students/12345/schedules"
      )
