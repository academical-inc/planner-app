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
ErrorStore = require '../../../app/scripts/stores/ErrorStore'
{ActionTypes} = require '../../../app/scripts/constants/PlannerConstants'


describe 'ErrorStore', ->

  beforeEach ->
    @payloads = {}  # Add the action types
    @dispatch = ErrorStore.dispatchCallback
    H.spyOn ErrorStore, "emitChange"
    H.rewire ErrorStore, {}  # Rewire any private state

  afterEach ->
    @restore() if @restore?

  describe 'when error action received', ->


