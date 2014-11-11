
React = require 'react'
$     = require 'jquery'
R     = React.DOM

PersonalEventForm = React.createClass(

  componentDidMount: ->
    opts =
      step: 15
      selectOnBlur: true
      scrollDefault: 'now'

    $(@refs.startInput.getDOMNode()).timepicker opts
    $(@refs.endInput.getDOMNode()).timepicker opts


  renderInput: (id, label, {ref, type, placeholder, inputGroup, val}={})->
    type ?= "text"

    inputProps =
      className: "form-control"
      type: type
      id: id
      ref: ref
      placeholder: placeholder
      defaultValue: val

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

    days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

    clockIcon = R.i className: "fa fa-clock-o fa-fw"
    startInput = @renderInput startId, "Start time", ref: startRef,\
      val: @props.startTime, inputGroup: clockIcon, placeholder: "10:00am"
    endInput = @renderInput endId, "End time", ref: endRef,\
      val: @props.endTime, inputGroup: clockIcon, placeholder: "11:30am"

    R.form role: "pla-personal-event-form form",
      @renderInput nameId, "Name", placeholder: "e.g. gym"
      R.div className: "row",
        R.div className: "col-md-6", startInput
        R.div className: "col-md-6", endInput
      R.div className: "form-group",
        R.select className: "form-control selectpicker", multiple: true,
          (R.option key: day, day for day in days)


)

module.exports = PersonalEventForm

