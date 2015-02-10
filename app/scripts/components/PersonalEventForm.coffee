
React       = require 'react'
$           = require 'jquery'
ModalMixin  = require '../mixins/ModalMixin'
I18nMixin   = require '../mixins/I18nMixin'
DateUtils   = require '../utils/DateUtils'
UIConstants = require('../constants/PlannerConstants').Ui
R           = React.DOM


PersonalEventForm = React.createClass(

  mixins: [I18nMixin, ModalMixin]

  getInitialState: ->
    @props.initialState || {
      checkedDays: [DateUtils.getDayForDate DateUtils.now()]
    }

  componentDidMount: ->
    opts =
      step: 15
      selectOnBlur: true
      scrollDefault: 'now'

    $(@refs.startTime.getDOMNode()).timepicker opts
    $(@refs.endTime.getDOMNode()).timepicker opts
    return

  handleStartTimeChange: (e)->
    @setState startTime: e.target.value

  handleEndTimeChange: (e)->
    @setState endTime: e.target.value

  handleDayChecked: (e)->
    day     = e.target.value
    checked = e.target.checked
    checkedDays = @state.checkedDays.slice 0
    if checked == true
      checkedDays = checkedDays.concat [day]
    else
      checkedDays.splice checkedDays.indexOf(day)
    @setState checkedDays: checkedDays

  handleSubmit: (e)->
    e.preventDefault()

    name = @refs.name.getDOMNode()
    startTime = @refs.startTime.getDOMNode()
    endTime = @refs.endTime.getDOMNode()
    # @state.checkedDays

    # TODO grab data and perform action

    # Clean up inputs
    name.value = ''
    @setState
      startTime: ''
      endTime: ''
      checkedDays: [DateUtils.getDayForDate DateUtils.now()]
    # Close
    @hide()

  renderInput: (id, label, {ref, type, placeholder, inputGroup,\
      val, onChange}={})->
    type ?= "text"

    inputProps =
      className: "form-control"
      type: type
      id: id
      ref: ref
      placeholder: placeholder
      defaultValue: val if not onChange?
      value: val if onChange?
      onChange: onChange

    if inputGroup?
      R.div className: "form-group",
        R.label htmlFor: id, label
        R.div className: "input-group",
          R.input inputProps
          R.span className: "input-group-addon", inputGroup
    else
      R.div className: "form-group",
        R.label htmlFor: id, label
        R.input inputProps

  renderBody: (formId)->
    nameId  = "personal-event-name-input"
    startId = "personal-event-start-time-input"
    endId   = "personal-event-end-time-input"

    days = UIConstants.days

    clockIcon = R.i className: "fa fa-clock-o fa-fw"
    startInput = @renderInput startId, @t("eventForm.start"),
      val: @state.startTime
      onChange: @handleStartTimeChange
      inputGroup: clockIcon
      placeholder: "10:00am"
      ref: "startTime"
    endInput = @renderInput endId, @t("eventForm.end"),
      val: @state.endTime
      onChange: @handleEndTimeChange
      inputGroup: clockIcon
      placeholder: "11:30am"
      ref: "endTime"

    R.form className: formId, role: "form", id: formId, onSubmit: @handleSubmit,
      @renderInput nameId, @t("eventForm.name"), ref: "name",\
        placeholder: @t("eventForm.namePlaceholder")
      R.div className: "row",
        R.div className: "col-md-6", startInput
        R.div className: "col-md-6", endInput
      R.div className: "form-group",
        R.label null, @t("eventForm.days")
        R.div className: "days",
          days.map (day)=>
            R.label className: "checkbox-inline", key: day,
              R.input(
                type: "checkbox"
                value: day
                checked: @state.checkedDays.indexOf(day) != -1
                onChange: @handleDayChecked
              )
              day

  render: ->
    ids = UIConstants.ids

    formId = "pla-personal-event-form"
    @renderModal(
      ids.PERSONAL_EVENT_MODAL
      @t("eventForm.header")
      @renderBody(formId)
      {accept: {form: formId}}
    )

)

module.exports = PersonalEventForm

