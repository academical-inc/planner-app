
H            = require '../../SpecHelper.coffee'
ScheduleList = require '../../../app/scripts/components/ScheduleList'


describe "ScheduleList", ->

  beforeEach ->
    @mockScheduleStore = H.spyObj "ScheduleStore", {
      addChangeListener: undefined
      removeChangeListener: undefined
      getCurrent: null
      getAll: []
    }
    @topRestore = H.rewire ScheduleList,
      ScheduleStore: @mockScheduleStore
      Dropdown: H.mockComponent()

  afterEach ->
    @topRestore()


  describe "#componentDidMount", ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire ScheduleList,
        "MediaQueries.matchesMDAndUp": H.spy("matcher", retVal: false)
        $: @mock$

    afterEach ->
      @restore()

    it 'should init jquery slide menu if screen size is SM or smaller', ->
      scheduleList = H.render ScheduleList

      expect(@mock$).toHaveBeenCalledWith scheduleList.getDOMNode()
      expect(@mock$El.mmenu).toHaveBeenCalled()

    it 'should not init jquery slide menu if screen size is MD or larger', ->
      H.rewire ScheduleList,
        "MediaQueries.matchesMDAndUp": H.spy("matcher", retVal: true)
      scheduleList = H.render ScheduleList

      expect(@mock$).not.toHaveBeenCalled()
      expect(@mock$El.mmenu).not.toHaveBeenCalled()

    it 'should subscribe to stores', ->
      scheduleList = H.render ScheduleList
      expect(@mockScheduleStore.addChangeListener).toHaveBeenCalledWith \
        scheduleList.onChange


  describe '#componentWillUnmount', ->

    it 'unsubscribes from stores', ->
      scheduleList = H.render ScheduleList
      scheduleList.componentWillUnmount()
      expect(@mockScheduleStore.removeChangeListener).toHaveBeenCalledWith \
        scheduleList.onChange

  describe '#getState', ->

    beforeEach ->
      @store = {
        getCurrent: {id: "sch1", name: "sch1"}
        getAll: [{id: "sch1", name: "sch1"}, {id: "sch2", name: "sch2"}]
        addChangeListener: undefined
        removeChangeListener: undefined
      }

    it 'creates state correctly based on store', ->
      H.rewire ScheduleList, ScheduleStore: H.spyObj "ScheduleStore", @store
      list = H.render ScheduleList
      state = list.getState()
      expect(state).toEqual
        current: "sch1"
        schedules: @store.getAll

    it 'creates state correctly when no schedules and no current', ->
      @store.getCurrent = null
      @store.getAll = []
      H.rewire ScheduleList, ScheduleStore: H.spyObj "ScheduleStore", @store
      list = H.render ScheduleList
      H.spyOn(list, "renderSpinner").and.returnValue "spinner"
      state = list.getState()
      expect(state).toEqual
        current: "spinner"
        schedules: []

