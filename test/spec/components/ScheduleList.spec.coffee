
helper       = require '../../SpecHelper.coffee'
ScheduleList = require '../../../app/scripts/components/ScheduleList'

describe "ScheduleList", ->

  describe "#componentDidMount", ->

    beforeEach ->
      [@mock$, @mock$El] = helper.mock$()

    afterEach ->
      @restore()

    it 'should init jquery slide menu if screen size is SM or smaller', ->
      @restore = helper.rewire ScheduleList,
        {"mq.matchesMDAndUp": helper.spy("matcher", retVal: false)}
      scheduleList = helper.render ScheduleList, {$: @mock$}

      expect(@mock$).toHaveBeenCalledWith(scheduleList.getDOMNode())
      expect(@mock$El.mmenu).toHaveBeenCalled()

    it 'should init jquery slide menu if screen size is MD or larger', ->
      @restore = helper.rewire ScheduleList,
        {"mq.matchesMDAndUp": helper.spy("matcher", retVal: true)}
      scheduleList = helper.render ScheduleList, {$: @mock$}

      expect(@mock$).not.toHaveBeenCalled()
      expect(@mock$El.mmenu).not.toHaveBeenCalled()
