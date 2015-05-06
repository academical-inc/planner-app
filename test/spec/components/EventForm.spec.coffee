
Moment    = require 'moment'
H         = require '../../SpecHelper.coffee'
EventForm = require '../../../app/scripts/components/EventForm'


describe "EventForm", ->

  beforeEach ->
    @actions = H.spyObj "Actions", ["addEvent"]
    @store   = H.spyObj "Store", [
      "addChangeListener"
      "removeChangeListener"
      "getStartEnd"
    ]
    @global  = H.rewire EventForm,
      EventFormStore: @store
      PlannerActions: @actions
      _utcOffset: -> -240

  afterEach ->
    @global()

  describe "#componentDidMount", ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire EventForm, $: @mock$
      @form = H.render EventForm, initialState: checkedDays: [1]

    afterEach ->
      @restore()

    it 'should init jquery timepicker on time inputs with correct options', ->
      @form = H.render EventForm, initialState: checkedDays: [1]
      expect(@mock$).toHaveBeenCalledWith @form.refs.startTime.getDOMNode()
      expect(@mock$).toHaveBeenCalledWith @form.refs.endTime.getDOMNode()
      expect(@mock$El.timepicker.calls.count()).toEqual 2

    it 'should init datepicker plugin', ->
      @form = H.render EventForm, initialState: checkedDays: [1]
      expect(@mock$).toHaveBeenCalledWith @form.refs.repeatUntil.getDOMNode()
      expect(@mock$El.datepicker).toHaveBeenCalled()

    it 'should subscribe to store', ->
      expect(@store.addChangeListener).toHaveBeenCalledWith @form.onChange

  describe "#componentWillUnmount", ->

    it 'should unsubscribe from store', ->
      form = H.render EventForm, initialState: checkedDays: [1]
      form.componentWillUnmount()
      expect(@store.removeChangeListener).toHaveBeenCalledWith form.onChange

  describe "#handleDayChecked", ->

    beforeEach ->
      @e = target: value: "5"
      @form = H.render EventForm, initialState: checkedDays: [1,3]
      H.spyOn @form, "setState"

    describe 'updates checkedDays state correctly', ->

      it 'when checking a day', ->
        @e.target.value = "5"
        @e.target.checked = true
        @form.handleDayChecked @e
        expect(@form.setState).toHaveBeenCalledWith checkedDays: [1,3,5]

      it 'when unchecking a day', ->
        @e.target.value   = "1"
        @e.target.checked = false
        @form.handleDayChecked @e
        expect(@form.setState).toHaveBeenCalledWith checkedDays: [3]

  describe '#getStartEnd', ->

    assertDates = (date, offset, expected)->
      expect(date.utcOffset()).toEqual offset
      expect(date.date()).toEqual expected.date()
      expect(date.day()).toEqual expected.day()
      expect(date.hours()).toEqual expected.hours()
      expect(date.minutes()).toEqual expected.minutes()

    beforeEach ->
      @restore = H.rewire EventForm,
        "CurrentWeekStore.week": -> 12  # Week of march 16/2015
      @form = H.render EventForm, initialState: checkedDays: []
      @st   = "10:00am"
      @et   = "3:15pm"

    afterEach ->
      @restore()

    it 'computes correctly given start and end time strs and day', ->
      sd = Moment.utc [2015, 2, 17, 10, 0]  # Tuesday
      ed = Moment.utc [2015, 2, 17, 15, 15]
      [resStart, resEnd] = @form.getStartEnd(@st, @et, 2)
      assertDates resStart,-240, sd
      assertDates resEnd, -240, ed

    it 'computes correctly when day is sunday', ->
      sd = Moment.utc [2015, 2, 22, 10, 0]  # Sunday
      ed = Moment.utc [2015, 2, 22, 15, 15]
      [resStart, resEnd] = @form.getStartEnd(@st, @et, 7)
      assertDates resStart,-240, sd
      assertDates resEnd, -240, ed


  describe "#handleSubmit", ->

    beforeEach ->
      H.rewire EventForm,
        "_.setTimeAndFormat": -> "2015-04-19T10:00-05:00"
        "UiConstants.DEFAULT_EVENT_COLOR": "red"
      @form = H.render EventForm, initialState: checkedDays: [1], defUntil: true
      @start = Moment.utc()
      @end   = Moment(@start).hours(@start.hours()+1)
      H.spyOn @form, "getStartEnd", retVal: [@start, @end]
      H.spyOn @form, "getState", retVal: checkedDays: [1]

    it 'grabs and submits form data correctly when repeat until not present', ->
      @form.setState checkedDays: [3,1,7], =>
        @form.refs.name.getDOMNode().value = "Name"
        @form.refs.startTime.getDOMNode().value = "10:00am"
        @form.refs.endTime.getDOMNode().value = "3:00pm"

        @form.handleSubmit preventDefault: ->
        expect(@form.getStartEnd).toHaveBeenCalledWith "10:00am", "3:00pm", 1
        expect(@actions.addEvent).toHaveBeenCalledWith(
          "Name", @start, @end, ["WE", "MO", "SU"], undefined, "red"
        )

    it 'submits repeat until when provided', ->
      @form.setState checkedDays: [3,1,7], defUntil: false, =>
        @form.refs.name.getDOMNode().value = "Name"
        @form.refs.startTime.getDOMNode().value = "10:00am"
        @form.refs.endTime.getDOMNode().value = "3:00pm"
        @form.refs.repeatUntil.getDOMNode().value = "2015-04-19"

        @form.handleSubmit preventDefault: ->
        expect(@form.getStartEnd).toHaveBeenCalledWith "10:00am", "3:00pm", 1
        expect(@actions.addEvent).toHaveBeenCalledWith(
          "Name", @start, @end, ["WE", "MO", "SU"], "2015-04-19T10:00-05:00", "red"
        )


    it 'clears the inputs', ->
      @form.handleSubmit preventDefault: ->
      expect(@form.refs.name.getDOMNode().value).toEqual ''
      expect(@form.refs.startTime.getDOMNode().value).toEqual ''
      expect(@form.refs.endTime.getDOMNode().value).toEqual ''
      expect(@form.state.checkedDays.length).toEqual 1

    it 'does not submit data when missing fields', ->
      name        = @form.refs.name.getDOMNode()
      startTime   = @form.refs.startTime.getDOMNode()
      endTime     = @form.refs.endTime.getDOMNode()
      repeatUntil = @form.refs.endTime.getDOMNode()
      @form.setState checkedDays: [], defUntil: false, =>
        name.value = ""
        startTime.value = ""
        endTime.value = ""
        repeatUntil.value = ""
        @form.handleSubmit preventDefault: ->
        expect(name.parentElement.className).toContain 'has-error'
        expect(startTime.parentElement.className).toContain 'has-error'
        expect(endTime.parentElement.className).toContain 'has-error'
        expect(@form.refs.daysGroup.getDOMNode().className).toContain 'has-error'
        expect(@form.refs.repeatUntilGroup.getDOMNode().className).toContain 'has-error'


  describe "#renderInput", ->

    beforeEach ->
      @form = H.render EventForm, initialState: checkedDays: [1], defUntil: true

    getInput = (form, {inputGroup, onChange}={})->
      form.renderInput "id", "label", ref: "ref", onChange: onChange,\
        placeholder: "placeholder", val: "defVal", inputGroup: inputGroup

    assertInputProps = (tree, onChangeSet=false)->
      expect(tree.props.className).toEqual "form-group"

      input = H.findWithTag tree, "input"
      label = H.findWithTag tree, "label"

      expect(label.props.children).toEqual "label"
      expect(input.ref).toEqual "ref"
      expect(input.props.type).toEqual "text"
      expect(input.props.id).toEqual "id"
      expect(input.props.placeholder).toEqual "placeholder"
      expect(input.props.value).toEqual "defVal" if onChangeSet
      expect(input.props.defaultValue).toEqual "defVal" if not onChangeSet

    it 'sets value prop when onChange handler prop is provided', ->
      tree = getInput @form, onChange: ->
      assertInputProps tree, true

    it 'sets value prop when onChange handler prop is not provided', ->
      tree = getInput @form
      assertInputProps tree

    it 'creates input group correctly when creating bootstrap input group', ->
      tree = getInput @form, inputGroup: "@"
      assertInputProps tree

      expect(-> H.findWithClass(tree, "input-group")).not.toThrow()

      span = H.findWithTag tree, "span"
      expect(span.props.className).toEqual "input-group-addon"
      expect(span.props.children).toEqual "@"

    it 'does not create input group when not creating one', ->
      tree = getInput @form
      assertInputProps tree

      expect(-> H.findWithClass(tree, "input-group")).toThrow()
      expect(H.scryWithTag(tree, "span").length).toEqual 0


  describe "#render", ->

    beforeEach ->
      @state = {
        startTime:   "10:00am"
        endTime:     "11:30am"
        checkedDays: [3]
        defUntil: true
      }
      @days = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
      @expected = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
      @restore = H.rewire EventForm,\
        UiConstants:
          DAYS: @days
          ids: EVENT_MODAL: "modal-id"
          selectors: EVENT_MODAL: "#modal-id"

    afterEach ->
      @restore()

    assertRenderedState = (form, state)->
      startInput = H.findWithId form, "event-start-time-input"
      endInput   = H.findWithId form, "event-end-time-input"
      days       = H.findWithClass form, "days"

      expect(startInput.props.value).toEqual state.startTime
      expect(endInput.props.value).toEqual state.endTime

      checkedDays = H.findAllInTree days, (el)->
        H.TestUtils.isDOMComponent(el) and el.props.checked == true
      expect(checkedDays.length).toEqual state.checkedDays.length
      for day in checkedDays
        expect(state.checkedDays.indexOf(day.props.value)).not.toEqual -1

    it 'renders the form with the correct days', ->
      form = H.render EventForm, initialState: checkedDays: [1], defUntil: true
      daysDiv = H.findWithClass form, "days"
      days = daysDiv.props.children

      expect(days.length).toEqual @expected.length
      days.forEach (day, i)=>
        expect(day.props.children[1]).toEqual @expected[i]

        dayInput = day.props.children[0]
        expect(dayInput.props.value).toEqual i+1

    it 'renders the form correctly based on initial state', ->
      form = H.render EventForm, initialState: @state
      assertRenderedState form, @state

    it 'updates form correctly when state is updated', ->
      form = H.render EventForm, initialState: checkedDays: [], defUntil: true
      form.setState @state, =>
        assertRenderedState form, @state
