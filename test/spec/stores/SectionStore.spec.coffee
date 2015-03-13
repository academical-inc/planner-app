
H                = require '../../SpecHelper'
SectionStore     = require '../../../app/scripts/stores/SectionStore'
ChildStoreHelper = require '../../../app/scripts/utils/ChildStoreHelper'
{ActionTypes}    = require '../../../app/scripts/constants/PlannerConstants'


describe 'SectionStore', ->

  childStoreHelper = (scheduleId, map, current)->
    map     ?= {}
    current ?= []
    store   = current: -> id: scheduleId
    helper = new ChildStoreHelper(store, 'sections', map, current)
    H.spyOn helper, 'wait'
    helper

  beforeEach ->
    @currentSchedId = "sch1"
    @sections =
      sch1: [
        {id: "sec1", credits: 3}
        {id: "sec2", credits: 2}
        {id: "sec3", credits: 3}
      ]
      sch2: [
        {id: "sec1", credits: 3}
        {id: "sec5", credits: 1}
        {id: "sec6", credits: 3}
      ]
    @schedules = [
      {id: @currentSchedId, sections: @sections.sch1}
      {id: "sch2", sections: @sections.sch2}
    ]

    @payloads =
      open:
        action:
          type: ActionTypes.OPEN_SCHEDULE
      getAllSuccess:
        action:
          type: ActionTypes.GET_SCHEDULES_SUCCESS
      add:
        action:
          type: ActionTypes.ADD_SECTION
      remove:
        action:
          type: ActionTypes.REMOVE_SECTION
      createSched:
        action:
          type: ActionTypes.CREATE_SCHEDULE_SUCCESS
      delSched:
        action:
          type: ActionTypes.DELETE_SCHEDULE_SUCCESS

    @dispatch = SectionStore.dispatchCallback
    @current  = SectionStore.sections
    @credits  = SectionStore.credits
    @count    = SectionStore.count
    @childStoreHelper = childStoreHelper.bind null, @currentSchedId
    H.spyOn SectionStore, "emitChange"
    @restore = H.rewire SectionStore,
      _: @childStoreHelper()

  afterEach ->
    @restore() if @restore?


  describe 'init', ->

    it 'initializes store correctly', ->
      expect(@current()).toEqual []
      expect(SectionStore.dispatchToken).toBeDefined()


  describe 'when OPEN_SCHEDULE received', ->

    it 'sets current sections corretly according to current schedule id', ->
      H.rewire SectionStore,
        _: @childStoreHelper @sections, @sections.sch2
      expect(@current()).toEqual @sections.sch2
      expect(@credits()).toEqual 7
      expect(@count()).toEqual 3

      @dispatch @payloads.open
      expect(@current()).toEqual @sections.sch1
      expect(@credits()).toEqual 8
      expect(@count()).toEqual 3

    it 'does nothing if opening already open schedule', ->
      H.rewire SectionStore,
        _: @childStoreHelper @sections, @sections.sch1
      expect(@current()).toEqual @sections.sch1
      expect(@credits()).toEqual 8
      expect(@count()).toEqual 3

      @dispatch @payloads.open
      expect(@current()).toEqual @sections.sch1
      expect(@credits()).toEqual 8
      expect(@count()).toEqual 3


  describe 'when GET_SCHEDULES_SUCCESS received', ->

    it 'inits current sections correctly based on current schedule', ->
      expect(@current()).toEqual []
      @payloads.getAllSuccess.action.schedules = @schedules

      @dispatch @payloads.getAllSuccess
      expect(SectionStore.__get__("_").elementsMap).toEqual @sections
      expect(@current()).toEqual @sections.sch1


  describe 'when ADD_SECTION received', ->

    it 'adds section to current sections', ->
      expect(@current()).toEqual []
      @payloads.add.action.section = id: "sec100", credits: 3
      @dispatch @payloads.add
      expect(@count()).toEqual 1
      expect(@current()[0]).toEqual id: "sec100", credits: 3
      expect(@credits()).toEqual 3


  describe 'when REMOVE_SECTION received', ->

    it 'does nothing when no sections present', ->
      expect(@current()).toEqual []
      @payloads.remove.action.sectionId = "sec100"
      @dispatch @payloads.remove
      expect(@current()).toEqual []

    it 'removes specified section', ->
      H.rewire SectionStore,
        _: @childStoreHelper @sections, @sections.sch1
      expect(@credits()).toEqual 8
      expect(@count()).toEqual 3
      @payloads.remove.action.sectionId = "sec1"
      @dispatch @payloads.remove
      expect(@credits()).toEqual 5
      expect(@count()).toEqual 2
      expect(@current()).toEqual [{id: "sec2", credits: 2}, {id: "sec3", credits: 3}]


  describe 'when CREATE_SCHEDULE_SUCCESS received', ->

    it 'adds new empty sections from added schedule', ->
      H.rewire SectionStore,
        _: childStoreHelper "sch3", @sections, @sections.sch1
      @payloads.createSched.action.schedule = id: "sch3"
      @dispatch @payloads.createSched
      expect(SectionStore.__get__("_").elementsMap.sch3).toBeDefined()
      expect(@current()).toEqual []


  describe 'when DELETE_SCHEDULE_SUCCESS received', ->

    it 'adds removes sections from removed schedule', ->
      map = sch1: @schedules[0].sections, sch2: @schedules[1].sections
      H.rewire SectionStore,
        _: @childStoreHelper map, @schedules[1].sections
      @payloads.delSched.action.scheduleId = @schedules[1].id
      expect(@current()).toEqual @schedules[1].sections
      @dispatch @payloads.delSched
      expect(SectionStore.__get__("_").elementsMap[@schedules[1].id]).toBeUndefined()
      expect(@current()).toEqual @schedules[0].sections
