
H            = require '../../SpecHelper'
WeekCalendar = require '../../../app/scripts/components/WeekCalendar'


describe 'WeekCalendar', ->

  describe '#componentDidMount', ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire WeekCalendar, $: @mock$

    afterEach ->
      @restore

    it 'should initialize the fullcalendar plugin', ->
      cal = H.render WeekCalendar
      expect(@mock$).toHaveBeenCalledWith(cal.getDOMNode())
      expect(@mock$El.fullCalendar).toHaveBeenCalled()


