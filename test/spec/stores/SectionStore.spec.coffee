
H            = require '../../SpecHelper'
SectionStore = require '../../../app/scripts/stores/SectionStore'
{ActionTypes} = require '../../../app/scripts/constants/PlannerConstants'


describe 'SectionStore', ->

  beforeEach ->
    @currentSchedId = "sch1"
    @sections =
      sch1: [
        {id: "sec1"}
        {id: "sec2"}
        {id: "sec3"}
      ]
      sch2: [
        {id: "sec1"}
        {id: "sec5"}
        {id: "sec6"}
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

    @dispatch = SectionStore.dispatchCallback
    @current  = SectionStore.getCurrentSections
    H.spyOn SectionStore, "emitChange"
    @restore = H.rewire SectionStore,
      "PlannerDispatcher.waitFor": H.spy "waitFor"
      ScheduleStore: H.spyObj "ScheduleStore", getCurrent: id: @currentSchedId
      _sectionsMap: {}
      _currentSections: []

  afterEach ->
    @restore() if @restore?


  describe 'init', ->

    it 'initializes store correctly', ->
      expect(@current()).toEqual []
      expect(SectionStore.dispatchToken).toBeDefined()


  describe 'when OPEN_SCHEDULE received', ->

    it 'sets current sections corretly according to current schedule id', ->
      H.rewire SectionStore,
        _sectionsMap: @sections
        _currentSections: @sections.sch2
      expect(@current()).toEqual @sections.sch2

      @dispatch @payloads.open
      expect(@current()).toEqual @sections.sch1

    it 'does nothing if opening already open schedule', ->
      H.rewire SectionStore,
        _sectionsMap: @sections
        _currentSections: @sections.sch1
      expect(@current()).toEqual @sections.sch1

      @dispatch @payloads.open
      expect(@current()).toEqual @sections.sch1


  describe 'when GET_SCHEDULES_SUCCESS received', ->

    it 'inits current sections correctly based on current schedule', ->
      expect(@current()).toEqual []
      @payloads.getAllSuccess.action.schedules = @schedules

      @dispatch @payloads.getAllSuccess
      expect(SectionStore.__get__("_sectionsMap")).toEqual @sections
      expect(@current()).toEqual @sections.sch1


  describe 'when ADD_SECTION received', ->

    it 'adds section to current sections', ->
      expect(@current()).toEqual []
      @payloads.add.action.section = id: "sec100"
      @dispatch @payloads.add
      expect(@current().length).toEqual 1
      expect(@current()[0]).toEqual id: "sec100"


  describe 'when REMOVE_SECTION received', ->

    it 'does nothing when no sections present', ->
      expect(@current()).toEqual []
      @payloads.remove.action.sectionId = "sec100"
      @dispatch @payloads.remove
      expect(@current()).toEqual []

    it 'removes specified section', ->
      H.rewire SectionStore,
        _sectionsMap: @sections
        _currentSections: @sections.sch1
      expect(@current().length).toEqual 3
      @payloads.remove.action.sectionId = "sec1"
      @dispatch @payloads.remove
      expect(@current().length).toEqual 2
      expect(@current()).toEqual [{id: "sec2"}, {id: "sec3"}]

