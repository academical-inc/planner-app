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

H             = require '../../SpecHelper'
ScheduleStore = require '../../../app/scripts/stores/ScheduleStore'
{ActionTypes} = require '../../../app/scripts/constants/PlannerConstants'


assertSingle = (length, schedules, current, actual, expected, expectedCurrent)->
  expectedCurrent ?= actual
  expect(schedules.length).toEqual length
  expect(actual).toEqual expected
  expect(current).toEqual expectedCurrent

assertAll = (length, schedules, current, expectedAll, expectedCurrent)->
  expect(schedules.length).toEqual length
  expect(schedules).toEqual expectedAll
  expect(current).toEqual expectedCurrent


describe 'ScheduleStore', ->

  beforeEach ->
    @schedules =
      toDelete: [
        {name: "Schedule 1", id: "sch1"}
        {name: "Schedule 2", id: "sch2", del: true}
      ]
      toCreate: [
        {name: "Schedule 3"}
        {name: "Schedule 4"}
      ]
      dirty: [
        {name: "Schedule 3", dirty: true}
        {name: "Schedule 4", dirty: true}
      ]
      clean: [
        {name: "Schedule 1", id: "sch1"}
        {name: "Schedule 2", id: "sch2"}
      ]

    @payloads =
      open:
        action:
          type: ActionTypes.OPEN_SCHEDULE
      create:
        action:
          type: ActionTypes.CREATE_SCHEDULE
      createSuccess:
        action:
          type: ActionTypes.CREATE_SCHEDULE_SUCCESS
      createFail:
        action:
          type: ActionTypes.CREATE_SCHEDULE_FAIL
      delete:
        action:
          type: ActionTypes.DELETE_SCHEDULE
      deleteSuccess:
        action:
          type: ActionTypes.DELETE_SCHEDULE_SUCCESS
      deleteFail:
        action:
          type: ActionTypes.DELETE_SCHEDULE_FAIL
      getAllSuccess:
        action:
          type: ActionTypes.GET_SCHEDULES_SUCCESS
      updateName:
        action:
          type: ActionTypes.UPDATE_SCHEDULE_NAME
      saveSuccess:
        action:
          type: ActionTypes.SAVE_SCHEDULE_SUCCESS
      saveFail:
        action:
          type: ActionTypes.SAVE_SCHEDULE_FAIL

    @dispatch    = ScheduleStore.dispatchCallback
    @all         = ScheduleStore.all
    @current     = ScheduleStore.current
    @_get        = ScheduleStore.__get__
    H.spyOn ScheduleStore, "emitChange"

    H.rewire ScheduleStore,
      _schedules: []
      _current: null
      _lastCurrent: null

  afterEach ->
    @restore() if @restore?


  describe 'init', ->

    it 'initializes store correctly', ->
      expect(@all()).toEqual []
      expect(@current()).toBeNull()
      expect(ScheduleStore.dispatchToken).toBeDefined()


  describe 'when OPEN_SCHEDULE received', ->

    it 'sets current schedule correctly when opening a dirty schedule', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat [@schedules.dirty[0]]
        _current: @schedules.clean[0]
        _lastCurrent: @schedules.clean[1]
      @payloads.open.action.schedule = name: "Schedule 3"
      expect(@current()).toEqual @all()[0]
      @dispatch @payloads.open
      expect(@current()).toEqual @all()[2]
      expect(@_get("_lastCurrent")).toBeNull()

    it 'sets current schedule correctly when dirty and repeated name', ->
      H.rewire ScheduleStore,
        _schedules: [
          @schedules.clean[0]
          {name: "Same", x: 1}
          {name: "Same", x: 5}
        ]
        _current: @schedules.clean[0]
      @payloads.open.action.schedule = name: "Same"
      expect(@current()).toEqual @all()[0]
      @dispatch @payloads.open
      expect(@current()).toEqual @all()[1]
      expect(@_get("_lastCurrent")).toBeNull()

    it 'sets current schedule correctly when opening a clean schedule', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.open.action.schedule = id: "sch2", name: "Schedule 2"
      expect(@current()).toEqual @all()[0]
      @dispatch @payloads.open
      expect(@current()).toEqual @all()[1]
      expect(@_get("_lastCurrent")).toBeNull()


  describe 'when CREATE_SCHEDULE received', ->

    it 'adds provided schedule to list and assigns current and last current when
    schedules already present', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean
        _current: @schedules.clean[1]
      @payloads.create.action.schedule = @schedules.toCreate[0]
      expect(@all().length).toEqual 2
      expect(@_get("_lastCurrent")).toBeNull()

      @dispatch @payloads.create
      assertSingle 3, @all(), @current(), @all()[2], {name: "Schedule 3", dirty: true}
      expect(@_get("_lastCurrent")).toEqual @schedules.clean[1]

    it 'adds provided schedule to list and assigns current when list empty and
    does not assign last current', ->
      @payloads.create.action.schedule = @schedules.toCreate[0]
      expect(@all().length).toEqual 0
      expect(@current()).toBeNull()
      expect(@_get("_lastCurrent")).toBeNull()

      @dispatch @payloads.create
      assertSingle 1, @all(), @current(), @all()[0], {name: "Schedule 3", dirty: true}
      expect(@_get("_lastCurrent")).toBeNull()


  describe 'when CREATE_SCHEDULE_SUCCESS received', ->

    it 'updates the schedule provided from the server given the name, updates
    current if schedule to update is current, and nulls last current', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty
        _current: @schedules.dirty[0]
        _lastCurrent: @schedules.clean[0]
      @payloads.createSuccess.action.schedule =
        name: "Schedule 3"
        id: "sch3"
      assertSingle 4, @all(), @current(), @all()[2], {name: "Schedule 3", dirty: true}

      @dispatch @payloads.createSuccess
      assertSingle 4, @all(), @current(), @all()[2], {name: "Schedule 3", id: "sch3"}
      expect(@_get("_lastCurrent")).toBeNull()

    it 'updates the schedule provided from the server given the name, does not
    update current if schedule to update is not current, nulls last current', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty
        _current: @schedules.clean[0]
        _lastCurrent: @schedules.clean[0]
      @payloads.createSuccess.action.schedule =
        name: "Schedule 3"
        id: "sch3"
      assertSingle 4, @all(), @current(), @all()[2],
        {name: "Schedule 3", dirty: true}, @all()[0]

      @dispatch @payloads.createSuccess
      assertSingle 4, @all(), @current(), @all()[2],
        {name: "Schedule 3", id: "sch3"}, @all()[0]
      expect(@_get("_lastCurrent")).toBeNull()

    it 'updates the first found schedule with given name', ->
      same = name: "Same", dirty: true
      H.rewire ScheduleStore,
        _schedules: [@schedules.clean[0]].concat [same, H.$.extend(true, {}, same)]
        _current: same
        _lastCurrent: @schedules.clean[0]
      @payloads.createSuccess.action.schedule =
        name: "Same"
        id: "sch1"
      expect(@all().length).toEqual 3
      expect(@current()).toEqual @all()[1]

      @dispatch @payloads.createSuccess
      expect(@all().length).toEqual 3
      expect(@all()[1]).toEqual name: "Same", id: "sch1"
      expect(@all()[2]).toEqual name: "Same", dirty: true
      expect(@current()).toEqual @all()[1]
      expect(@_get("_lastCurrent")).toBeNull()

    it 'does nothing if schedule to update not found', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty
      @payloads.createSuccess.action.schedule =
        name: "Poof"
        id: "schpoof"
      expect(@all().length).toEqual 4
      tmp = @all().concat []

      @dispatch @payloads.createSuccess
      expect(@all()).toEqual tmp


  describe 'when CREATE_SCHEDULE_FAIL received', ->

    it 'does nothing when dirty schedule not found', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.createSuccess.action.schedule = name: "Poof"
      tmp = @all().concat []
      @dispatch @payloads.createSuccess
      expect(@all()).toEqual tmp


    describe 'when created dirty schedule is current', ->

      it 'removes dirty schedule and assigns current to last current when not
      the first schedule', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.clean.concat @schedules.dirty
          _current: @schedules.dirty[0]
          _lastCurrent: @schedules.clean[0]
        @payloads.createFail.action.schedule = @schedules.toCreate[0]
        expect(@all().length).toEqual 4

        @dispatch @payloads.createFail
        assertAll 3, @all(), @current(),
          @schedules.clean.concat([@schedules.dirty[1]]), @all()[0]
        expect(@_get("_lastCurrent")).toBeNull()

      it 'removes dirty schedule and assigns current when first and only
      schedule', ->
        H.rewire ScheduleStore,
          _schedules: [@schedules.dirty[0]]
          _current: @schedules.dirty[0]
          _lastCurrent: null
        @payloads.createFail.action.schedule = @schedules.toCreate[0]
        expect(@all().length).toEqual 1

        @dispatch @payloads.createFail
        assertAll 0, @all(), @current(), [], null
        expect(@_get("_lastCurrent")).toBeNull()

      it 'removes dirty schedule and assigns current when first schedule and
      more than one schedule', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.dirty.concat []
          _current: @schedules.dirty[0]
        @payloads.createFail.action.schedule = @schedules.dirty[0]
        expect(@all().length).toEqual 2

        @dispatch @payloads.createFail
        assertAll 1, @all(), @current(), [@schedules.dirty[1]], @all()[0]
        expect(@_get("_lastCurrent")).toBeNull()


    describe 'when created dirty schedule is not current', ->

      it 'removes dirty schedule and mantains same current', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.clean.concat @schedules.dirty
          _current: @schedules.clean[0]
        @payloads.createFail.action.schedule = @schedules.toCreate[0]
        expect(@all().length).toEqual 4
        expect(@current()).toEqual @all()[0]

        @dispatch @payloads.createFail
        assertAll 3, @all(), @current(),
          @schedules.clean.concat([@schedules.dirty[1]]), @all()[0]
        expect(@_get("_lastCurrent")).toBeNull()


  describe 'when DELETE_SCHEDULE received', ->

    it 'does not delete a dirty schedule', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty
        _current: @schedules.clean[0]
      @payloads.delete.action.scheduleId = undefined
      tmp = @all().concat []
      @dispatch @payloads.delete
      expect(@all()).toEqual tmp

    it 'marks schedule as dirty delete', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.delete.action.scheduleId = @schedules.clean[1].id
      @dispatch @payloads.delete
      expect(@all()).toEqual [@schedules.clean[0], @schedules.toDelete[1]]
      expect(@current()).toEqual @all()[0]
      expect(@schedules.clean[1].del).toBe true


  describe 'when DELETE_SCHEDULE_SUCCESS received', ->

    describe 'when deleting current', ->

      it 'removes and reassigns current correctly when deleting first schedule', ->
        H.rewire ScheduleStore,
          _schedules: [@schedules.toDelete[1], @schedules.toDelete[0]]
          _current: @schedules.toDelete[1]
        @payloads.deleteSuccess.action.scheduleId = @schedules.toDelete[1].id
        @dispatch @payloads.deleteSuccess
        expect(@all()).toEqual [@schedules.toDelete[0]]
        expect(@current()).toEqual @all()[0]

      it 'removes reassigns current correctly when not deleting first schedule', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.toDelete.concat []
          _current: @schedules.toDelete[1]
        @payloads.deleteSuccess.action.scheduleId = @schedules.toDelete[1].id
        @dispatch @payloads.deleteSuccess
        expect(@all()).toEqual [@schedules.toDelete[0]]
        expect(@current()).toEqual @all()[0]

      it 'removes and reassigns current correctly when deleting the only
      schedule and creates a new one', ->
        createSpy = H.spy "createSpy", retVal: @schedules.toCreate[0]
        apiSpy    = H.spy "apiSpy"
        H.rewire ScheduleStore,
          _schedules: [@schedules.toDelete[1]]
          _current: @schedules.toDelete[1]
          "ApiUtils.createSchedule": apiSpy
          "ScheduleFactory.create": createSpy
        @payloads.deleteSuccess.action.scheduleId = @schedules.toDelete[1].id
        @dispatch @payloads.deleteSuccess
        expect(@all()).toEqual [@schedules.dirty[0]]
        expect(@current()).toEqual @all()[0]
        expect(createSpy).toHaveBeenCalled()
        expect(apiSpy).toHaveBeenCalled()

    describe 'when not deleting current', ->

      it 'removes from schedules', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.toDelete.concat []
          _current: @schedules.toDelete[0]
        @payloads.deleteSuccess.action.scheduleId = @schedules.toDelete[1].id
        @dispatch @payloads.deleteSuccess
        expect(@all()).toEqual [@schedules.toDelete[0]]
        expect(@current()).toEqual @all()[0]

    it 'does nothing if id is not found', ->
      H.rewire ScheduleStore, _schedules: @schedules.toDelete.concat []
      @payloads.deleteSuccess.action.scheduleId = "poof"
      expect(@all()).toEqual @schedules.toDelete
      @dispatch @payloads.deleteSuccess
      expect(@all()).toEqual @schedules.toDelete

    it 'does nothing if schedule is not marked for deletion', ->
      H.rewire ScheduleStore, _schedules: @schedules.clean.concat []
      @payloads.deleteSuccess.action.scheduleId = @schedules.clean[1].id
      expect(@all()).toEqual @schedules.clean
      @dispatch @payloads.deleteSuccess
      expect(@all()).toEqual @schedules.clean


  describe 'when DELETE_SCHEDULE_FAIL received', ->

    it 'unmarks schedule for deletion', ->
      H.rewire ScheduleStore, _schedules: @schedules.toDelete.concat []
      @payloads.deleteFail.action.scheduleId = @schedules.toDelete[1].id
      expect(@all()).toEqual @schedules.toDelete
      @dispatch @payloads.deleteFail
      expect(@all()).toEqual @schedules.clean


  describe 'when GET_SCHEDULES_SUCCESS received', ->

    it 'sets all schedules correctly and sets current schedule to first', ->
      @payloads.getAllSuccess.action.schedules = @schedules.clean.concat []
      expect(@all()).toEqual []
      expect(@current()).toBeNull()
      @dispatch @payloads.getAllSuccess
      expect(@all()).toEqual @schedules.clean
      expect(@current()).toEqual @schedules.clean[0]


  describe 'when UPDATE_SCHEDULE_NAME received', ->

    it 'updates schedule name and marks as dirty when current', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.updateName.action.scheduleId = "sch1"
      @payloads.updateName.action.name = "New name"
      @dispatch @payloads.updateName
      expected =
        id: "sch1"
        name: "New name"
        dirty: true
        prevName: "Schedule 1"
      assertSingle 2, @all(), @current(), @all()[0], expected, expected

    it 'updates schedule name and marks as dirty when not current', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.updateName.action.scheduleId = "sch2"
      @payloads.updateName.action.name = "New name"
      @dispatch @payloads.updateName
      expected =
        id: "sch2"
        name: "New name"
        dirty: true
        prevName: "Schedule 2"
      assertSingle 2, @all(), @current(), @all()[1], expected, @schedules.clean[0]


  describe 'when SAVE_SCHEDULE_SUCCESS received', ->

    it 'correctly updates dirty schedule (name) with response from server when not current', ->
      @schedules.dirty[0].name = "New name"
      @schedules.dirty[0].prevName = "Schedule 3"
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat [@schedules.dirty[0]]
        _current: @schedules.clean[0]
      expected =
        name: "New name"
        id: "sch3"
      @payloads.saveSuccess.action.schedule = expected
      @dispatch @payloads.saveSuccess
      assertSingle 3, @all(), @current(), @all()[2], expected, @schedules.clean[0]

    it 'correctly updates dirty schedule (name) with response from server when not current', ->
      @schedules.dirty[0].name = "New name"
      @schedules.dirty[0].prevName = "Schedule 3"
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat [@schedules.dirty[0]]
        _current: @schedules.dirty[0]
      expected =
        name: "New name"
        id: "sch3"
      @payloads.saveSuccess.action.schedule = expected
      @dispatch @payloads.saveSuccess
      assertSingle 3, @all(), @current(), @all()[2], expected, expected


  describe 'when SAVE_SCHEDULE_FAIL received', ->

    it 'correctly reverts name in dirty schedule when not current', ->
      @schedules.dirty[0].id = "sch3"
      @schedules.dirty[0].name = "New name"
      @schedules.dirty[0].prevName = "Schedule 3"
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat [@schedules.dirty[0]]
        _current: @schedules.clean[0]
      expected =
        name: "Schedule 3"
        id: "sch3"
      @payloads.saveFail.action.scheduleId = "sch3"
      @dispatch @payloads.saveFail
      assertSingle 3, @all(), @current(), @all()[2], expected, @schedules.clean[0]

    it 'correctly updates dirty schedule (name) with response from server when not current', ->
      @schedules.dirty[0].id = "sch3"
      @schedules.dirty[0].name = "New name"
      @schedules.dirty[0].prevName = "Schedule 3"
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat [@schedules.dirty[0]]
        _current: @schedules.dirty[0]
      expected =
        name: "Schedule 3"
        id: "sch3"
      @payloads.saveFail.action.scheduleId = "sch3"
      @dispatch @payloads.saveFail
      assertSingle 3, @all(), @current(), @all()[2], expected, expected
