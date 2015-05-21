
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
IconMixin   = require '../mixins/IconMixin'
OptionsItem = React.createFactory require './OptionsItem'
R           = React.DOM

ProfileBox = React.createClass(

  mixins: [I18nMixin, IconMixin]

  render: ->
    R.div className: "pla-profile-box",
      R.img src: @props.url
      R.div className: "profile-logout",
        R.span null, @props.name
        R.div className: "logout",
          R.img src: '/images/logout_icon.png'
          R.button
            className: "logout-button"
            @t("profile.logout")

)

module.exports = ProfileBox

