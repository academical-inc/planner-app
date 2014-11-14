
React     = require 'react'
$         = require 'jquery'
days      = require('../constants/PlannerConstants').days
DateUtils = require '../utils/DateUtils'
R         = React.DOM

PersonalEventForm = React.createClass(

  getInitialState: ->
    @props.initialState || {
      checkedDays: [DateUtils.getDayForDate DateUtils.now()]
    }

  componentDidMount: ->
    opts =
      step: 15
      selectOnBlur: true
      scrollDefault: 'now'

    $(@refs.startInput.getDOMNode()).timepicker opts
    $(@refs.endInput.getDOMNode()).timepicker opts
    return

  handleStartTimeChange: (e)->
    @setState $.extend({}, @state, startTime: e.target.value)

  handleEndTimeChange: (e)->
    @setState $.extend({}, @state, endTime: e.target.value)

  handleDayChecked: (e)->
    day     = e.target.value
    checked = e.target.checked
    checkedDays = @state.checkedDays.slice 0
    if checked == true
      checkedDays = checkedDays.concat [day]
    else
      checkedDays.splice checkedDays.indexOf(day)
    @setState $.extend({}, @state, checkedDays: checkedDays)

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

  render: ->
    nameId  = "personal-event-name-input"
    startId = "personal-event-start-time-input"
    endId   = "personal-event-end-time-input"

    startRef = "startInput"
    endRef   = "endInput"

    clockIcon = R.i className: "fa fa-clock-o fa-fw"
    startInput = @renderInput startId, "Start time",
      val: @state.startTime
      onChange: @handleStartTimeChange
      inputGroup: clockIcon
      placeholder: "10:00am"
      ref: startRef
    endInput = @renderInput endId, "End time",
      val: @state.endTime
      onChange: @handleEndTimeChange
      inputGroup: clockIcon
      placeholder: "11:30am"
      ref: endRef

    R.form className: "pla-personal-event-form", role: "form",
      @renderInput nameId, "Name", placeholder: "e.g. gym"
      R.div className: "row",
        R.div className: "col-md-6", startInput
        R.div className: "col-md-6", endInput
      R.div className: "form-group",
        R.label null, "Days"
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

)

module.exports = PersonalEventForm

