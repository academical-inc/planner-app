
React = require 'react'
$     = require 'jquery'
R     = React.DOM

PersonalEventForm = React.createClass(

  getInitialState: ->
    {
      startTime: "10:00am"
      endTime: "11:30am"
      day: "We"
    }

  componentDidMount: ->
    opts =
      step: 15
      selectOnBlur: true
      scrollDefault: 'now'

    $(@refs.startInput.getDOMNode()).timepicker opts
    $(@refs.endInput.getDOMNode()).timepicker opts
    return

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
      val: @state.startTime, inputGroup: clockIcon, placeholder: "10:00am"
    endInput = @renderInput endId, "End time", ref: endRef,\
      val: @state.endTime, inputGroup: clockIcon, placeholder: "11:30am"

    R.form className: "pla-personal-event-form", role: "form",
      @renderInput nameId, "Name", placeholder: "e.g. gym"
      R.div className: "row",
        R.div className: "col-md-6", startInput
        R.div className: "col-md-6", endInput
      R.div className: "form-group",
        R.label null, "Days"
        R.div className: "days",
          days.map ((day)->
            R.label className: "checkbox-inline", key: day,
              R.input(
                type: "checkbox"
                id: "day-input-#{day}",
                value: day
                defaultChecked: true if day == @state.day
              )
              day
          ).bind(this)

)

module.exports = PersonalEventForm

