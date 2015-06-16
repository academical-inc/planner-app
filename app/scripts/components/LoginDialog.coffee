
React         = require 'react'
ModalMixin    = require '../mixins/ModalMixin'
I18nMixin     = require '../mixins/I18nMixin'
IconMixin     = require '../mixins/IconMixin'
AppActions    = require '../actions/AppActions'
SchoolStore   = require '../stores/SchoolStore'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM


LoginDialog = React.createClass(

  mixins: [I18nMixin, ModalMixin, IconMixin]

  login: (connection)->
    @setState selected: connection
    AppActions.login connection

  getInitialState: ->
    selected: null

  renderLoginBtns: (providers=SchoolStore.school().identityProviders)->
    providers.map (provider)=>
      part = if provider.indexOf(".") != -1
        provider.split(".")[0]
      else
        provider.split("-")[0]
      R.a
        key: "login-#{part}"
        className: "btn btn-block btn-social btn-#{part}"
        onClick: @login.bind @, provider
        R.i className: "fa fa-#{part}"
        if @state.selected is part
          R.span null,
            @t("loginDialog.loading")
            @renderSpinner()
        else
          @t("loginDialog.#{part}")

  renderBody: ->
    R.div className: 'pla-login-dialog container-fluid',
      R.div className: 'col-md-6 providers',
        @renderLoginBtns()
      R.div className: 'col-md-6 reminder',
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
