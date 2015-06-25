
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
AppActions  = require '../actions/AppActions'
WeekControl = React.createFactory require './WeekControl'
R           = React.DOM

SchedulePageHeader = React.createClass(

  mixins: [I18nMixin]

  renderDuplicateButton: (loggedIn) ->
    onClickHandler = @props.duplicateScheduleHandler
    duplicateMessage = 'duplicateSchedule'
    if !loggedIn
      onClickHandler = @props.loginHandler
      duplicateMessage = 'loginToDuplicate'

    R.button className: 'btn btn-default', onClick: onClickHandler,
      R.img src: '/images/add_schedule_icon.png'
      R.span null, @t duplicateMessage

  render: ->
    loggedIn = @props.loggedIn
    R.section className: 'pla-schedule-header hidden-xs hidden-sm',
      R.nav className: 'navbar', role: 'navigation',
        R.div className: 'container-fluid',
          R.ul className: 'nav navbar-nav',
            R.div className: 'pla-logo-container',
              R.span className: 'vertical-align-helper'
              R.img src: '/images/academical_logo_blue.png'
          R.ul className: 'nav navbar-nav pla-week-container',
            R.span className: "vertical-align-helper", null
            WeekControl {}
          R.ul className: 'nav navbar-nav',
            R.span className: 'vertical-align-helper', null
            R.div className: 'pla-schedule-button',
              @renderDuplicateButton loggedIn
)

module.exports = SchedulePageHeader

