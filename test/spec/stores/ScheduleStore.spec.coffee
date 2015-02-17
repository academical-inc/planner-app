
H             = require '../../SpecHelper'
ScheduleStore = require '../../../app/scripts/stores/ScheduleStore'
{ActionTypes} = require '../../../app/scripts/constants/PlannerConstants'


describe 'ScheduleStore', ->

  beforeEach ->
    @schedules =
      dirty: [
        {name: "Schedule 3"}
        {name: "Schedule 4"}
      ]
      clean: [
        {name: "Schedule 1", id: "sch1"}
        {name: "Schedule 2", id: "sch2"}
      ]

    @payloads =
      create:
        action:
          type: ActionTypes.CREATE_SCHEDULE
      receiveSchedule:
        action:
          type: ActionTypes.CREATE_SCHEDULE_SUCCESS
      receiveAll:
        action:
          type: ActionTypes.GET_SCHEDULES_SUCCESS

    H.spyOn ScheduleStore, "emitChange"
    @dispatch = ScheduleStore.dispatchCallback
    @all      = ScheduleStore.getAll
    @current  = ScheduleStore.getCurrent

  afterEach ->
    H.rewire ScheduleStore,
      _schedules: []
      _current: null

  describe 'init', ->

    it 'initializes store correctly', ->
      expect(@all()).toEqual []
      expect(@current()).toBeNull()
      expect(ScheduleStore.dispatchToken).toBeDefined()


  describe 'when CREATE_SCHEDULE received', ->

    it 'adds provided schedule to list and assigns current when schedules
    already present', ->
      restore = H.rewire ScheduleStore, _schedules: @schedules.clean
      @payloads.create.action.schedule = @schedules.dirty[0]
      expect(@all().length).toEqual 2

      @dispatch @payloads.create
      expect(@all().length).toEqual 3
      expect(@all()[2].name).toEqual "Schedule 3"
      expect(@current().name).toEqual "Schedule 3"
      restore()

    it 'adds provided schedule to list and assigns current when list empty', ->
      @payloads.create.action.schedule = @schedules.dirty[0]
      expect(@all().length).toEqual 0

      @dispatch @payloads.create
      expect(@all().length).toEqual 1
      expect(@all()[0].name).toEqual "Schedule 3"
      expect(@current().name).toEqual "Schedule 3"


  describe 'when RECEIVE_CREATED_SCHEDULE received', ->

    beforeEach ->
      @restore = H.rewire ScheduleStore,
        _schedules: @schedules.clean.concat @schedules.dirty

    afterEach ->
      @restore()

    it 'updates the schedule provided from the server given the name', ->
      @payloads.receiveSchedule.action.schedule =
        name: "Schedule 3"
        id: "sch3"
      expect(@all().length).toEqual 4
      expect(@all()[2].name).toEqual "Schedule 3"
      expect(@all()[2].id).toBeUndefined()

      @dispatch @payloads.receiveSchedule
      expect(@all().length).toEqual 4
      expect(@all()[2].name).toEqual "Schedule 3"
      expect(@all()[2].id).toEqual "sch3"

    it 'does nothing if schedule to update not found', ->
      @payloads.receiveSchedule.action.schedule =
        name: "Poof"
        id: "schpoof"
      expect(@all().length).toEqual 4
      tmp = @all().concat []

      @dispatch @payloads.receiveSchedule
      expect(@all()).toEqual tmp


  describe 'when RECEIVE_SCHEDULES received', ->

    it 'sets all schedules correctly and sets current schedule to first', ->
      @payloads.receiveAll.action.schedules = @schedules.clean
      expect(@all()).toEqual []
      expect(@current()).toBeNull()
      @dispatch @payloads.receiveAll
      expect(@all()).toEqual @schedules.clean
      expect(@current()).toEqual @schedules.clean[0]



