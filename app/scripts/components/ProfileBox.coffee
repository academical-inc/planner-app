
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
IconMixin   = require '../mixins/IconMixin'
AppActions  = require '../actions/AppActions'
UserStore   = require '../stores/UserStore'
OptionsItem = React.createFactory require './OptionsItem'
R           = React.DOM

ProfileBox = React.createClass(

  mixins: [I18nMixin, IconMixin]

  logout: ->
    AppActions.logout()

  user: ->
    UserStore.user() || {
      name: @t "profile.user"
      picture: UiConstants.PROFILE_PLACEHOLDER
    }

  render: ->
    R.li className: "pla-profile-box",
      R.div className: "profile container-fluid",
        R.img className: "img-circle", src: @user().picture
        R.span null, @user().name
      R.div
        className: "logout container-fluid"
        onClick: @logout
        @imgIcon '/images/logout_icon.png'
        R.button
          className: "logout-button"
          @t("profile.logout")

)

module.exports = ProfileBox

