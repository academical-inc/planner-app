
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
        {"mq.matchesMDAndUp": H.spy("matcher", retVal: false)}
      scheduleList = H.render ScheduleList, {$: @mock$}

      expect(@mock$).toHaveBeenCalledWith scheduleList.getDOMNode()
      expect(@mock$El.mmenu).toHaveBeenCalled()

    it 'should init jquery slide menu if screen size is MD or larger', ->
      @restore = H.rewire ScheduleList,
        {"mq.matchesMDAndUp": H.spy("matcher", retVal: true)}
      scheduleList = H.render ScheduleList, {$: @mock$}

      expect(@mock$).not.toHaveBeenCalled()
      expect(@mock$El.mmenu).not.toHaveBeenCalled()
