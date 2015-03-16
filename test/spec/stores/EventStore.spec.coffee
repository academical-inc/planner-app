
H                = require '../../SpecHelper'
EventStore       = require '../../../app/scripts/stores/EventStore'
ChildStoreHelper = require '../../../app/scripts/utils/ChildStoreHelper'
{ActionTypes}    = require '../../../app/scripts/constants/PlannerConstants'


describe 'EventStore', ->

  childStoreHelper = (scheduleId, map, current)->
    map     ?= {}
    current ?= []
    store   = current: -> id: scheduleId
    helper = new ChildStoreHelper(store, 'events', map, current)
    H.spyOn helper, 'wait'
    helper

  beforeEach ->
    @currentSchedId = "sch1"
    @events =
      sch1: [
        {id: "ev1"}
        {id: "ev2"}
        {id: "ev3"}
      ]
      sch2: [
        {id: "ev1"}
        {id: "ev5"}
        {id: "ev6"}
      ]
    @schedules = [
      {id: @currentSchedId, events: @events.sch1}
      {id: "sch2", events: @events.sch2}
    ]

    @payloads =
      open:
        action:
          type: ActionTypes.OPEN_SCHEDULE
      getAllSuccess:
        action:
          type: ActionTypes.GET_SCHEDULES_SUCCESS
      createSched:
        action:
          type: ActionTypes.CREATE_SCHEDULE_SUCCESS
      delSched:
        action:
          type: ActionTypes.DELETE_SCHEDULE_SUCCESS
      saveSuccess:
        action:
          type: ActionTypes.SAVE_SCHEDULE_SUCCESS
      saveFail:
        action:
          type: ActionTypes.SAVE_SCHEDULE_FAIL
      add:
        action:
          type: ActionTypes.ADD_EVENT
      update:
        action:
          type: ActionTypes.UPDATE_EVENT
      remove:
        action:
          type: ActionTypes.REMOVE_EVENT

    @dispatch = EventStore.dispatchCallback
    @current  = EventStore.events
    @childStoreHelper = childStoreHelper.bind null, @currentSchedId
    @expandSpy = H.spy "expand"
    H.spyOn EventStore, "emitChange"
    @restore = H.rewire EventStore,
      _: @childStoreHelper()
      _currentSchool: -> utcOffset: -300
      "EventUtils.expandEventThruWeek": @expandSpy
      "ScheduleStore.current": -> id: null

  afterEach ->
    @restore() if @restore?


  describe 'init', ->

    it 'initializes store correctly', ->
      expect(@current()).toEqual []
      expect(EventStore.dispatchToken).toBeDefined()


  describe 'when OPEN_SCHEDULE received', ->

    it 'sets current events correctly according to current schedule id', ->
      H.rewire EventStore,
        _: @childStoreHelper @events, @events.sch2
      expect(@current()).toEqual @events.sch2
      @dispatch @payloads.open
      expect(@current()).toEqual @events.sch1

    it 'does nothing if opening already open schedule', ->
      H.rewire EventStore,
        _: @childStoreHelper @events, @events.sch1
      expect(@current()).toEqual @events.sch1
      @dispatch @payloads.open
      expect(@current()).toEqual @events.sch1


  describe 'when GET_SCHEDULES_SUCCESS received', ->

    it 'inits current events correctly based on current schedule', ->
      expect(@current()).toEqual []
      @payloads.getAllSuccess.action.schedules = @schedules
      @dispatch @payloads.getAllSuccess
      expect(EventStore.__get__("_").elementsMap).toEqual @events
      expect(@current()).toEqual @events.sch1


  describe 'when CREATE_SCHEDULE_SUCCESS received', ->

    it 'adds new empty events from added schedule', ->
      H.rewire EventStore,
        _: childStoreHelper "sch3", @events, @events.sch1
      @payloads.createSched.action.schedule = id: "sch3"
      @dispatch @payloads.createSched
      expect(EventStore.__get__("_").elementsMap.sch3).toBeDefined()
      expect(@current()).toEqual []


  describe 'when DELETE_SCHEDULE_SUCCESS received', ->

    it 'removes events from removed schedule', ->
      H.rewire EventStore, _: @childStoreHelper @events, @schedules[1].events
      @payloads.delSched.action.scheduleId = @schedules[1].id
      expect(@current()).toEqual @schedules[1].events
      @dispatch @payloads.delSched
      expect(EventStore.__get__("_").elementsMap[@schedules[1].id]).toBeUndefined()
      expect(@current()).toEqual @schedules[0].events


  describe 'when ADD_EVENT received', ->

    it 'adds event to current events, marks as dirty and expands', ->
      expect(@current()).toEqual []
      @payloads.add.action.event = id: "ev100"
      @dispatch @payloads.add
      expected = id: "ev100", dirty: true
      expect(@current()[0]).toEqual expected
      expect(@expandSpy).toHaveBeenCalledWith expected, -300


  describe 'when REMOVE_EVENT received', ->

    it 'does nothing when no events present', ->
      expect(@current()).toEqual []
      @payloads.remove.action.eventId = "ev100"
      @dispatch @payloads.remove
      expect(@current()).toEqual []

    it 'marks the specified event as dirty delete', ->
      H.rewire EventStore,
        _: @childStoreHelper @events, @events.sch1
      expect(@current()).toEqual @events.sch1
      @payloads.remove.action.eventId = "ev1"
      @dispatch @payloads.remove
      expect(@current().length).toEqual 3
      expect(@current()[0]).toEqual id: "ev1", del: true


  describe 'when SAVE_SCHEDULE_SUCCESS received', ->

    beforeEach ->
      @events.sch1 = [
        {id: "ev1"}, {id: "ev2", del: true}, {dirty: true}
      ]
      @response = id: "sch1", events: [
        {id: "ev1"}, {id: "ev3"}
      ]

    it 'updates saved schedule and current events when saved schedule is
    current', ->
      H.rewire EventStore,
        _: @childStoreHelper @events, @events.sch1
        "ScheduleStore.current": -> id: "sch1"
      @payloads.saveSuccess.action.schedule = @response
      @dispatch @payloads.saveSuccess
      expect(@current()).toEqual @response.events
      expect(EventStore.__get__("_").elementsMap.sch1).toEqual @response.events

    it 'updates saved schedule and not current events when saved schedule is not
    current', ->
      H.rewire EventStore,
        _: @childStoreHelper @events, @events.sch2
        "ScheduleStore.current": -> id: "sch2"
      @payloads.saveSuccess.action.schedule = @response
      @dispatch @payloads.saveSuccess
      expect(@current()).toEqual @events.sch2
      expect(EventStore.__get__("_").elementsMap.sch1).toEqual @response.events


  describe 'when SAVE_SCHEDULE_FAIL', ->

    describe 'when failed saved schedule is current', ->

      it 'removes all dirty added events from saved schedule and sets
      current', ->
        @events.sch1 = [ {id: "ev1"}, {dirty: true} ]
        H.rewire EventStore,
          _: @childStoreHelper @events, @events.sch1
          "ScheduleStore.current": -> id: "sch1"
        @payloads.saveFail.action.scheduleId = "sch1"
        @dispatch @payloads.saveFail
        expect(@current()).toEqual [{id: "ev1"}]
        expect(EventStore.__get__("_").elementsMap.sch1).toEqual [{id: "ev1"}]

      it 'undeletes all dirty deleted events from saved schedule and sets
      current', ->
        @events.sch1 = [ {id: "ev1"}, {id: "ev2", del: true} ]
        H.rewire EventStore,
          _: @childStoreHelper @events, @events.sch1
          "ScheduleStore.current": -> id: "sch1"
        @payloads.saveFail.action.scheduleId = "sch1"
        @dispatch @payloads.saveFail
        expected = [{id: "ev1"}, {id: "ev2"}]
        expect(@current()).toEqual expected
        expect(EventStore.__get__("_").elementsMap.sch1).toEqual expected


    describe 'when failed saved schedule is not current', ->

      it 'removes all dirty added events from saved schedule and sets current', ->
        @events.sch1 = [ {id: "ev1"}, {dirty: true} ]
        H.rewire EventStore,
          _: @childStoreHelper @events, @events.sch2
          "ScheduleStore.current": -> id: "sch2"
        @payloads.saveFail.action.scheduleId = "sch1"
        @dispatch @payloads.saveFail
        expect(@current()).toEqual @events.sch2
        expect(EventStore.__get__("_").elementsMap.sch1).toEqual [{id: "ev1"}]

      it 'undeletes all dirty deleted events from saved schedule and sets
      current', ->
        @events.sch1 = [ {id: "ev1"}, {id: "ev2", del: true} ]
        H.rewire EventStore,
          _: @childStoreHelper @events, @events.sch2
          "ScheduleStore.current": -> id: "sch2"
        @payloads.saveFail.action.scheduleId = "sch1"
        @dispatch @payloads.saveFail
        expected = [{id: "ev1"}, {id: "ev2"}]
        expect(@current()).toEqual @events.sch2
        expect(EventStore.__get__("_").elementsMap.sch1).toEqual expected
