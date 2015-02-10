
H            = require '../../SpecHelper.coffee'
ScheduleList = require '../../../app/scripts/components/ScheduleList'


describe "ScheduleList", ->

  describe "#componentDidMount", ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()

    afterEach ->
      @restore()

    it 'should init jquery slide menu if screen size is SM or smaller', ->
      @restore = H.rewire ScheduleList,
        "MediaQueries.matchesMDAndUp": H.spy("matcher", retVal: false)
        $: @mock$
        Dropdown: H.mockComponent()
      scheduleList = H.render ScheduleList

      expect(@mock$).toHaveBeenCalledWith scheduleList.getDOMNode()
      expect(@mock$El.mmenu).toHaveBeenCalled()

    it 'should not init jquery slide menu if screen size is MD or larger', ->
      @restore = H.rewire ScheduleList,
        "MediaQueries.matchesMDAndUp": H.spy("matcher", retVal: true)
        Dropdown: H.mockComponent()
      scheduleList = H.render ScheduleList

      expect(@mock$).not.toHaveBeenCalled()
      expect(@mock$El.mmenu).not.toHaveBeenCalled()
