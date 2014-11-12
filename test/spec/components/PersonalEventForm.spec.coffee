
helper            = require '../../SpecHelper.coffee'
PersonalEventForm = require '../../../app/scripts/components/PersonalEventForm'

describe "PersonalEventForm", ->

  describe "#componentDidMount", ->

    beforeEach ->
      [@mock$, @mock$El] = helper.mock$()
      @restore = helper.rewire PersonalEventForm, $: @mock$

    afterEach ->
      @restore()

    it 'should init jquery timepicker on time inputs with correct options', ->
      form = helper.render PersonalEventForm

      expect(@mock$).toHaveBeenCalledWith form.refs.startInput.getDOMNode()
      expect(@mock$).toHaveBeenCalledWith form.refs.endInput.getDOMNode()
      expect(@mock$El.timepicker.calls.count()).toEqual 2


  describe "#renderInput", ->

    beforeEach ->
      @form = helper.render PersonalEventForm

    it 'should returna DOM tree with an input containing the correct props', ->
      tree = @form.renderInput "id", "label",\
        ref: "ref", placeholder: "placeholder", val: "defVal"
      input = helper.findAllInTree tree, (el)->
        el.type == "input"
      label = helper.findAllInTree tree, (el)->
        el.type == "label"
      expect(label.length).toEqual 1
      expect(input.length).toEqual 1

      input = input[0]
      label = label[0]
      expect(label.props.children).toEqual "label"
      expect(input.ref).toEqual "ref"
      expect(input.props.type).toEqual "text"
      expect(input.props.id).toEqual "id"
      expect(input.props.placeholder).toEqual "placeholder"
      expect(input.props.defaultValue).toEqual "defVal"



    describe "when creating bootstrap input group", ->


    describe "when not creating bootstrap input group", ->



  describe "#render", ->

