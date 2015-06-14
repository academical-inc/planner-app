
React       = require 'react'
AppActions  = require '../actions/AppActions'
ErrorDialog = React.createFactory require './ErrorDialog'
R           = React.DOM


LandingPage = React.createClass(

  login: ->
    AppActions.login 'academical.co'

  componentDidMount: ->
    @refs.errorDialog.show() if @props.error?

  render: ->
    R.div className: 'pla-content container-fluid',
      R.div className: 'pla-landing-page',
        R.div className: 'login-box',
          R.a style: {cursor: "select"}, onClick: @login, "Login con WAAD"
      ErrorDialog ref: "errorDialog", error: @props.error

)

module.exports = LandingPage
