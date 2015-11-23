
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
