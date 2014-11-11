
helper       = require '../../SpecHelper'
WeekCalendar = require '../../../app/scripts/components/WeekCalendar'


describe 'WeekCalendar', ->

  describe '#componentDidMount', ->

    beforeEach ->
      [@mock$, @mock$El] = helper.mock$()

    it 'should initialize the fullcalendar plugin', ->
      cal = helper.render WeekCalendar, $: @mock$
      expect(@mock$).toHaveBeenCalledWith(cal.getDOMNode())
      expect(@mock$El.fullCalendar).toHaveBeenCalled()


