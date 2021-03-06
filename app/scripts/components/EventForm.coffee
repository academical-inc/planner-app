#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

$              = require 'jquery'
React          = require 'react'
ModalMixin     = require '../mixins/ModalMixin'
I18nMixin      = require '../mixins/I18nMixin'
FormMixin      = require '../mixins/FormMixin'
IconMixin      = require '../mixins/IconMixin'
DateUtils      = require '../utils/DateUtils'
Utils          = require '../utils/Utils'
SchoolStore    = require '../stores/SchoolStore'
EventFormStore = require '../stores/EventFormStore'
WeekStore      = require '../stores/WeekStore'
AppActions     = require '../actions/AppActions'
R              = React.DOM

{UiConstants, MAX_EVENT_NAME_LENGTH} = require '../constants/PlannerConstants'

# Private
_ = $.extend true, {}, Utils, DateUtils
_school = SchoolStore.school()
_term   = _school.terms[0]

EventForm = React.createClass(

  mixins: [I18nMixin, ModalMixin, FormMixin, IconMixin]

  # TODO Test
  getState: ->
    # Transform momentjs SU as 0 to 7
    [startDt, endDt] = EventFormStore.getStartEnd()
    date     = startDt or endDt or _.now()
    day      = if date.day() == 0 then 7 else date.day()
    defChecked = @isCurrentBeforeTermEnd()
    checkedDays: [day]
    startTime: _.getTimeStr startDt if startDt?
    endTime: _.getTimeStr endDt if endDt?
    defChecked: defChecked
    defDisabled: not defChecked

  getInitialState: ->
    @props.initialState or @getState()

  onChange: ->
    @setState @getState()
    @show()

  onShown: ->
    @refs.name.getDOMNode().focus()

  buildDate: (time, day)->
    date = _.getUtcTimeFromStr time
    date = _.setWeek date, WeekStore.currentWeekNumber()
    date = _.setDay date, day
    date = _.inUtcOffset date, _school.utcOffset
    _.format date

  getStartEnd: (startTime, endTime, day)->
    startDt = @buildDate startTime, day
    endDt   = @buildDate endTime, day
    [startDt, endDt]

  # TODO Test
  defaultRepeatUntil: (startDt)->
    termEnd = _.utcFromStr _term.endDate, "YYYY-MM-DD"
    _.setTimeAndFormat termEnd, startDt, _school.utcOffset

  # TODO Test
  selectedRepeatUntil: (startDt)->
    repUntilVal = @refs.repeatUntil.getDOMNode().value
    date        = _.utcFromStr repUntilVal, "YYYY-MM-DD"
    _.setTimeAndFormat date, startDt, _school.utcOffset

  # TODO Test
  getRepeatUntil: (startDt)->
    if @state.defChecked is true
      @defaultRepeatUntil startDt
    else
      @selectedRepeatUntil startDt

  isCurrentBeforeTermEnd: ()->
    WeekStore.currentWeekDate().isBefore _.utcFromStr(_term.endDate)

  componentDidMount: ->
    EventFormStore.addChangeListener @onChange
    dp     = $(@refs.repeatUntil.getDOMNode())
    tpOpts =
      step: 15
      selectOnBlur: true
      scrollDefault: 'now'
    dpOpts =
      autoclose: true
      startDate: _.now().toDate()
      container: UiConstants.selectors.EVENT_MODAL
      format: "yyyy-mm-dd"

    $(@refs.startTime.getDOMNode()).timepicker tpOpts
    $(@refs.endTime.getDOMNode()).timepicker tpOpts
    dp.datepicker(dpOpts).on 'show', @handleDatepickerShow.bind @, dp
    return

  componentWillUnmount: ->
    EventFormStore.removeChangeListener @onChange

  # TODO Test
  handleDatepickerShow: (dp, e)->
    earliestDay = Math.min @state.checkedDays...
    [startDt, endDt] = @getStartEnd '12:00am', '12:00am', earliestDay
    dp.datepicker 'setStartDate', _.date(startDt).toDate()

  handleStartTimeChange: (e)->
    @setState startTime: e.target.value

  handleEndTimeChange: (e)->
    @setState endTime: e.target.value

  handleDayChecked: (e)->
    day     = parseInt e.target.value, 10
    checked = e.target.checked
    checkedDays = @state.checkedDays.concat []
    if checked == true
      checkedDays = checkedDays.concat [day]
    else
      _.removeAt checkedDays, checkedDays.indexOf(day)
    @setState checkedDays: checkedDays

  handleDefUntilChecked: (e)->
    checked = not @state.defChecked
    @refs.repeatUntil.getDOMNode().value = '' if checked
    @setState defChecked: checked

  handleRepeatUntilFocus: (e)->
    @setState defChecked: false if @state.defChecked is true

  handleSubmit: (e)->
    e.preventDefault()
    @clearFormErrors()
    @validateForm (fields)=>
      name        = fields.name
      startTime   = fields.startTime
      endTime     = fields.endTime
      days        = @state.checkedDays.map (dayNo)-> _.getDayStr dayNo
      earliestDay = Math.min @state.checkedDays...
      color       = UiConstants.DEFAULT_EVENT_COLOR
      [startDt, endDt] = @getStartEnd fields.startTime, endTime, earliestDay
      repeatUntil = @getRepeatUntil startDt

      AppActions.addEvent name, startDt, endDt, days, repeatUntil, color

      # Clean up inputs
      @clearFields()
      @refs.repeatUntil.getDOMNode().value = ''
      @setState @getState()
      # Close
      @hide()

  formFields: ->
    ["name", "startTime", "endTime"]

  validateDays: ->
    @refs.daysGroup.getDOMNode() if @state.checkedDays.length == 0

  validateRepeatUntil: ->
    if (not @state.defChecked) and (not @refs.repeatUntil.getDOMNode().value)
      @refs.repeatUntilGroup.getDOMNode()

  customValidations: ->
    [@validateDays, @validateRepeatUntil]

  renderInput: (id, {label, ref, type, placeholder, inputGroup, onFocus,\
      val, maxLength, onChange}={})->
    type ?= "text"

    inputProps =
      className: "form-control"
      type: type
      id: id
      ref: ref
      placeholder: placeholder
      maxLength: maxLength
      defaultValue: val if not onChange?
      value: val if onChange?
      onChange: onChange
      onFocus: onFocus

    if inputGroup?
      R.div className: "form-group",
        R.label htmlFor: id, label if label?
        R.div className: "input-group",
          R.input inputProps
          R.span className: "input-group-addon", inputGroup
    else
      R.div className: "form-group",
        R.label htmlFor: id, label if label?
        R.input inputProps

  renderBody: (formId)->
    nameId        = "event-name-input"
    startId       = "event-start-time-input"
    endId         = "event-end-time-input"
    repeatUntilId = 'event-repeat-until'

    termEnd   = _.format _term.endDate, "LL"
    clockIcon = @icon "clock-o"
    calIcon   = @icon "calendar"
    startInput = @renderInput startId,
      val: @state.startTime
      onChange: @handleStartTimeChange
      inputGroup: clockIcon
      placeholder: @t("eventForm.start")
      ref: "startTime"
    endInput = @renderInput endId,
      val: @state.endTime
      onChange: @handleEndTimeChange
      inputGroup: clockIcon
      placeholder: @t("eventForm.end")
      ref: "endTime"
    repeatUntil = @renderInput repeatUntilId,
      placeholder: @t("eventForm.untilDate"),
      inputGroup: calIcon
      onFocus: @handleRepeatUntilFocus
      ref: 'repeatUntil'

    R.form className: formId, role: "form", id: formId, onSubmit: @handleSubmit,
      @renderInput nameId,
        ref: "name"
        placeholder: @t("eventForm.namePlaceholder")
        maxLength: MAX_EVENT_NAME_LENGTH
      R.div className: "row",
        R.div className: "col-md-6", startInput
        R.div className: "col-md-6", endInput
      R.div className: "form-group", ref: "daysGroup",
        R.label className: "daysLabel", @t("eventForm.days")
        R.div className: "days",
          [1,2,3,4,5,6,7].map (dayNo)=>
            day = _.getDayStr dayNo
            R.label className: "checkbox-inline", key: day,
              R.input(
                type: "checkbox"
                value: dayNo
                checked: @state.checkedDays.indexOf(dayNo) != -1
                onChange: @handleDayChecked
              )
              "#{day[0]}#{day[1].toLowerCase()}"
      R.div className: "form-group", ref: "repeatUntilGroup",
        R.label null, @t("eventForm.until")
        R.div className: "row",
          R.div className: "col-md-5 col-vertical-align",
            R.label className: "checkbox-inline",
              R.input
                type: "checkbox",
                checked: @state.defChecked
                disabled: @state.defDisabled
                onChange: @handleDefUntilChecked
              R.span null, termEnd + " "
              R.em null, "(#{@t('eventForm.defaultUntil')})"
          R.div className: "col-md-2 col-vertical-align",
            R.span className: "label label-info", @t('eventForm.or')
          R.div className: "col-md-5 col-vertical-align",
            repeatUntil

  render: ->
    formId = "pla-event-form"
    @renderModal(
      UiConstants.ids.EVENT_MODAL
      @t("eventForm.header")
      @renderBody(formId)
      accept: form: formId, text: @t "eventForm.addEvent"
    )

)

module.exports = EventForm

