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

H         = require '../../SpecHelper'
PollUtils = require '../../../app/scripts/utils/PollUtils'


describe 'PollUtils', ->

  beforeEach ->
    @pollFnSpy = H.spy "pollFnSpy"
    @pollIntvl = 100
    @userId    = 123
    jasmine.clock().install()

  afterEach ->
    jasmine.clock().uninstall()

  describe '.poll', ->

    beforeEach ->
      H.spyOn PollUtils, "clear"
      @updateSpy = H.spy "updateSpy"
      @logoutSpy = H.spy "logoutSpy"
      @restore = H.rewire PollUtils, AppActions: {
        updateSchedules: @updateSpy
        logout: @logoutSpy
      }

    afterEach ->
      @restore()

    it 'calls pollFunc correctly at each interval', ->
      PollUtils.poll @userId,
        pollFunc: @pollFnSpy
        untTimestamp: 500
        pollInterval: @pollIntvl

      expect(@pollFnSpy).not.toHaveBeenCalled()
      jasmine.clock().tick @pollIntvl + 1
      expect(@pollFnSpy).toHaveBeenCalledWith @userId, 500, undefined
      @pollFnSpy.calls.reset()
      jasmine.clock().tick (@pollIntvl * 2) + 1
      expect(@pollFnSpy.calls.allArgs()).toEqual([
        [@userId, 500, undefined]
        [@userId, 500, undefined]
      ])

    it 'performs logout when time has passed token expiration date', ->
      PollUtils.poll @userId,
        untTimestamp: 150
        pollInterval: @pollIntvl
        now: 200

      jasmine.clock().tick 101
      expect(PollUtils.clear.calls.count()).toEqual 1
      expect(@logoutSpy.calls.count()).toEqual 1
      expect(@updateSpy.calls.count()).toEqual 0

    it 'performs update when time has not passed token expiration date', ->
      PollUtils.poll @userId,
        untTimestamp: 150
        pollInterval: @pollIntvl
        now: 100

      jasmine.clock().tick 101
      expect(PollUtils.clear.calls.count()).toEqual 0
      expect(@logoutSpy.calls.count()).toEqual 0
      expect(@updateSpy.calls.count()).toEqual 1

  describe '.clear', ->

    it 'clears interval correctly', ->
      PollUtils.poll @userId,
        pollFunc: @pollFnSpy
        untTimestamp: 500
        pollInterval: @pollIntvl

      expect(@pollFnSpy).not.toHaveBeenCalled()
      jasmine.clock().tick 101
      expect(@pollFnSpy).toHaveBeenCalled()
      PollUtils.clear()
      jasmine.clock().tick 100
      expect(@pollFnSpy.calls.count()).toEqual 1
