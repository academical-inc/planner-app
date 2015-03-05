
React                  = require 'react'
$                      = require 'jquery'
ModalMixin             = require '../mixins/ModalMixin'
I18nMixin              = require '../mixins/I18nMixin'
FormMixin              = require '../mixins/FormMixin'
DateUtils              = require '../utils/DateUtils'
HelperUtils            = require '../utils/HelperUtils'
PersonalEventFormStore = require '../stores/PersonalEventFormStore'
PlannerActions         = require '../actions/PlannerActions'
{UiConstants}          = require '../constants/PlannerConstants'
R                      = React.DOM

# Private
_ = $.extend true, {}, HelperUtils, DateUtils

# TODO add repeat until option. Do not force to school period
PersonalEventForm = React.createClass(

  mixins: [I18nMixin, ModalMixin, FormMixin]

  getState: ->
    [@startDate, @endDate] = PersonalEventFormStore.getStartEnd()
    date = @startDate or @endDate or _.now()
    checkedDays: [date.day()]
    startTime: _.getTimeStr @startDate if @startDate?
    endTime: _.getTimeStr @endDate if @endDate?

  getInitialState: ->
    @props.initialState or @getState()

  onChange: ->
    @setState @getState()
    @show()

  getStartEnd: (startTime, endTime, day)->
    if @startDate? and @endDate?
      if @startDate.day() != day
        @startDate = _.setDay @startDate, day
        @endDate   = _.setDay @endDate, day
      [@startDate, @endDate]
    else
      # TODO use current date being viewed in calendar instead of now
      # related to repeat until option
      startDate = _.getTimeFromStr startTime
      endDate   = _.getTimeFromStr endTime
      startDate = _.setDay startDate, day
      endDate   = _.setDay endDate, day
      [startDate, endDate]

  componentDidMount: ->
    PersonalEventFormStore.addChangeListener @onChange
    opts =
      step: 15
      selectOnBlur: true
      scrollDefault: 'now'

    $(@refs.startTime.getDOMNode()).timepicker opts
    $(@refs.endTime.getDOMNode()).timepicker opts
    return

  componentWillUnmount: ->
    PersonalEventFormStore.removeChangeListener @onChange

  handleStartTimeChange: (e)->
    @setState startTime: e.target.value

  handleEndTimeChange: (e)->
    @setState endTime: e.target.value

  handleDayChecked: (e)->
    day     = parseInt e.target.value, 10
    checked = e.target.checked
    checkedDays = @state.checkedDays.slice 0
    if checked == true
      checkedDays = checkedDays.concat [day]
    else
      _.removeAt checkedDays, checkedDays.indexOf(day)
    @setState checkedDays: checkedDays

  formFields: ->
    ["name", "startTime", "endTime"]

  validateDays: ->
    @refs.daysGroup.getDOMNode() if @state.checkedDays.length == 0

  customValidations: ->
    [@validateDays]

  handleSubmit: (e)->
    e.preventDefault()
    @clearFormErrors()
    @validateForm (fields)=>
      name        = fields.name
      startTime   = fields.startTime
      endTime     = fields.endTime
      days        = @state.checkedDays.map (dayNo)-> _.getDayStr dayNo
      earliestDay = Math.min @state.checkedDays...

      [startDate, endDate] = @getStartEnd startTime, endTime, earliestDay
      PlannerActions.addPersonalEvent name, startDate, endDate, days

      # Clean up inputs
      @clearFields()
      @setState @getState()
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

    days = UiConstants.days

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
      R.div className: "form-group", ref: "daysGroup",
        R.label null, @t("eventForm.days")
        R.div className: "days",
          [1,2,3,4,5,6,0].map (dayNo)=>
            day = _.getDayStr dayNo
            R.label className: "checkbox-inline", key: day,
              R.input(
                type: "checkbox"
                value: dayNo
                checked: @state.checkedDays.indexOf(dayNo) != -1
                onChange: @handleDayChecked
              )
              "#{day[0]}#{day[1].toLowerCase()}"

  render: ->
    formId = "pla-personal-event-form"
    @renderModal(
      UiConstants.ids.PERSONAL_EVENT_MODAL
      @t("eventForm.header")
      @renderBody(formId)
      {accept: {form: formId}}
    )

)

module.exports = PersonalEventForm

