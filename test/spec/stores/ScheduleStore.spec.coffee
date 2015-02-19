
$             = require 'jquery'
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
      getAllSuccess:
        action:
          type: ActionTypes.GET_SCHEDULES_SUCCESS

    H.spyOn ScheduleStore, "emitChange"
    @dispatch = ScheduleStore.dispatchCallback
    @all      = ScheduleStore.getAll
    @current  = ScheduleStore.getCurrent

    H.rewire ScheduleStore,
      _schedules: []
      _current: null


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
      @payloads.open.action.schedule = name: "Schedule 3"
      expect(@current()).toEqual @all()[0]
      @dispatch @payloads.open
      expect(@current()).toEqual @all()[2]

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

    it 'sets current schedule correctly when opening a clean schedule', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.open.action.schedule = id: "sch2", name: "Schedule 2"
      expect(@current()).toEqual @all()[0]
      @dispatch @payloads.open
      expect(@current()).toEqual @all()[1]


  describe 'when CREATE_SCHEDULE received', ->

    it 'adds provided schedule to list and assigns current when schedules
    already present', ->
      H.rewire ScheduleStore, _schedules: @schedules.clean
      @payloads.create.action.schedule = @schedules.toCreate[0]
      expect(@all().length).toEqual 2

      @dispatch @payloads.create
      assertSingle 3, @all(), @current(), @all()[2], {name: "Schedule 3", dirty: true}

    it 'adds provided schedule to list and assigns current when list empty', ->
      @payloads.create.action.schedule = @schedules.toCreate[0]
      expect(@all().length).toEqual 0

      @dispatch @payloads.create
      assertSingle 1, @all(), @current(), @all()[0], {name: "Schedule 3", dirty: true}


  describe 'when CREATE_SCHEDULE_SUCCESS received', ->

    it 'updates the schedule provided from the server given the name, and
    updates current if schedule to update is current', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty
        _current: @schedules.dirty[0]
      @payloads.createSuccess.action.schedule =
        name: "Schedule 3"
        id: "sch3"
      assertSingle 4, @all(), @current(), @all()[2], {name: "Schedule 3", dirty: true}

      @dispatch @payloads.createSuccess
      assertSingle 4, @all(), @current(), @all()[2], {name: "Schedule 3", id: "sch3"}

    it 'updates the schedule provided from the server given the name, does
    not update current if schedule to update is not current', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty
        _current: @schedules.clean[0]
      @payloads.createSuccess.action.schedule =
        name: "Schedule 3"
        id: "sch3"
      assertSingle 4, @all(), @current(), @all()[2],
        {name: "Schedule 3", dirty: true}, @all()[0]

      @dispatch @payloads.createSuccess
      assertSingle 4, @all(), @current(), @all()[2],
        {name: "Schedule 3", id: "sch3"}, @all()[0]

    it 'updates the first found schedule with given name', ->
      same = name: "Same", dirty: true
      H.rewire ScheduleStore,
        _schedules: [same, $.extend(true, {}, same)]
        _current: same
      @payloads.createSuccess.action.schedule =
        name: "Same"
        id: "sch1"
      expect(@all().length).toEqual 2
      expect(@current()).toEqual @all()[0]

      @dispatch @payloads.createSuccess
      expect(@all().length).toEqual 2
      expect(@all()[0]).toEqual name: "Same", id: "sch1"
      expect(@all()[1]).toEqual name: "Same", dirty: true
      expect(@current()).toEqual @all()[0]

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

    it 'does nothing whe dirty schedule not found', ->
      H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat []
        _current: @schedules.clean[0]
      @payloads.createSuccess.action.schedule = name: "Poof"
      tmp = @all().concat []
      @dispatch @payloads.createSuccess
      expect(@all()).toEqual tmp

    describe 'when created dirty schedule is current', ->

      it 'removes dirty schedule and assigns current when not the first
      schedule', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.clean.concat @schedules.dirty
          _current: @schedules.dirty[0]
        @payloads.createFail.action.schedule = @schedules.toCreate[0]
        expect(@all().length).toEqual 4

        @dispatch @payloads.createFail
        assertAll 3, @all(), @current(),
          @schedules.clean.concat([@schedules.dirty[1]]), @all()[1]

      it 'removes dirty schedule and assigns current when first and only
      schedule', ->
        H.rewire ScheduleStore,
          _schedules: [@schedules.dirty[0]]
          _current: @schedules.dirty[0]
        @payloads.createFail.action.schedule = @schedules.toCreate[0]
        expect(@all().length).toEqual 1

        @dispatch @payloads.createFail
        assertAll 0, @all(), @current(), [], null

      it 'removes dirty schedule and assigns current when first schedule and
      more than one schedule', ->
        H.rewire ScheduleStore,
          _schedules: @schedules.dirty.concat []
          _current: @schedules.dirty[0]
        @payloads.createFail.action.schedule = @schedules.dirty[0]
        expect(@all().length).toEqual 2

        @dispatch @payloads.createFail
        assertAll 1, @all(), @current(), [@schedules.dirty[1]], @all()[0]


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


  describe 'when GET_SCHEDULES_SUCCESS received', ->

    it 'sets all schedules correctly and sets current schedule to first', ->
      @payloads.getAllSuccess.action.schedules = @schedules.clean.concat []
      expect(@all()).toEqual []
      expect(@current()).toBeNull()
      @dispatch @payloads.getAllSuccess
      expect(@all()).toEqual @schedules.clean
      expect(@current()).toEqual @schedules.clean[0]


