
React         = require 'react'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
AppActions    = require '../actions/AppActions'
SchoolStore   = require '../stores/SchoolStore'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

_onLoginCallback = null

executeOnLoginCallback = ->
  if !!_onLoginCallback
    _onLoginCallback()
    _onLoginCallback = null

LoginDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin, IconMixin]

  login: (connection)->
    @setState selected: connection
    executeOnLoginCallback()
    AppActions.login connection

  registerOnLoginCallback: (callback) ->
    _onLoginCallback = callback

  getInitialState: ->
    selected: null

  renderLoginBtns: (providers=SchoolStore.school().identityProviders)->
    providers.map (connection, i)=>
      part = if connection.indexOf(".") != -1
        connection.split(".")[0]
      else
        connection.split("-")[0]
      R.div key: "login-#{part}",
        R.a
          className: "btn btn-block btn-social btn-#{part}"
          onClick: @login.bind @, connection
          R.i className: "fa fa-#{part}"
          if @state.selected is connection
            R.span null,
              @t("loginDialog.loading")
              @renderSpinner()
          else
            @t("loginDialog.#{part}")
        if i != providers.length-1
          R.h6 className: "divider", @t("loginDialog.or")

  renderBody: ->
    R.div className: 'pla-login-dialog container-fluid',
      R.div className: 'providers',
        @renderLoginBtns()
      R.div className: 'reminder',
        R.h4 className: "header", @t("loginDialog.reminderHeader")
        @t("loginDialog.reminder").map (msg, i)->
          R.p key: "reminder-#{i}", msg
        R.a href: UiConstants.site.PRIVACY, @t("landing.footer.privacy")

  render: ->
    @renderModal(
      UiConstants.ids.LOGIN_MODAL
      @t "loginDialog.header"
      @renderBody()
      accept: show: false
      cancel: show: false
    )

)

module.exports = LoginDialog
