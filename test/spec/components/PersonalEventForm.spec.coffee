
H                 = require '../../SpecHelper.coffee'
PersonalEventForm = require '../../../app/scripts/components/PersonalEventForm'


describe "PersonalEventForm", ->

  describe "#componentDidMount", ->

    beforeEach ->
      [@mock$, @mock$El] = H.mock$()
      @restore = H.rewire PersonalEventForm, $: @mock$

    afterEach ->
      @restore()

    it 'should init jquery timepicker on time inputs with correct options', ->
      form = H.render PersonalEventForm

      expect(@mock$).toHaveBeenCalledWith form.refs.startInput.getDOMNode()
      expect(@mock$).toHaveBeenCalledWith form.refs.endInput.getDOMNode()
      expect(@mock$El.timepicker.calls.count()).toEqual 2


  describe "#handleDayChecked", ->

    beforeEach ->
      @e    = target: value: "Mo"
      @form = H.render PersonalEventForm, initialState: checkedDays: ["We"]
      spyOn @form, "setState"

    describe 'updates checkedDays state correctly', ->

      it 'when checking a day', ->
        @e.target.checked = true
        @form.handleDayChecked @e
        expect(@form.setState).toHaveBeenCalledWith checkedDays: ["We", "Mo"]

      it 'when unchecking a day', ->
        @e.target.value   = "We"
        @e.target.checked = false
        @form.handleDayChecked @e
        expect(@form.setState).toHaveBeenCalledWith checkedDays: []


  describe "#renderInput", ->

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

    beforeEach ->
      @form = H.render PersonalEventForm

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

    assertRenderedState = (form, state)->
      startInput = H.findWithId form, "personal-event-start-time-input"
      endInput   = H.findWithId form, "personal-event-end-time-input"

      expect(startInput.props.value).toEqual state.startTime
      expect(endInput.props.value).toEqual state.endTime

      checkedDays = H.findAllInTree form, (el)->
        el.props.checked == true
      expect(checkedDays.length).toEqual state.checkedDays.length
      for day in checkedDays
        expect(state.checkedDays.indexOf(day.props.value)).not.toEqual -1

    beforeEach ->
      @state = {
        startTime:   "10:00am"
        endTime:     "11:30am"
        checkedDays: "We"
      }
      @days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
      @restore = H.rewire PersonalEventForm,\
        days: @days

    afterEach ->
      @restore()

    it 'renders the form with the correct days', ->
      @form = H.render PersonalEventForm
      daysDiv = H.findWithClass @form, "days"
      days = daysDiv.props.children

      expect(days.length).toEqual @days.length
      days.forEach ((day, i)->
        expect(day.props.children[1]).toEqual @days[i]

        dayInput = day.props.children[0]
        expect(dayInput.props.value).toEqual @days[i]
      ).bind this

    it 'renders the form correctly based on initial state', ->
      @form = H.render PersonalEventForm, initialState: @state
      assertRenderedState @form, @state

    it 'updates form correctly when state is updated', ->
      @form = H.render PersonalEventForm
      @form.setState @state, (->
        assertRenderedState @form, @state
      ).bind this
