
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
IconMixin   = require '../mixins/IconMixin'
OptionsItem = React.createFactory require './OptionsItem'
R           = React.DOM

ProfileBox = React.createClass(

  mixins: [I18nMixin, IconMixin]

  render: ->
    R.li className: "pla-profile-box",
      R.div className: "profile container-fluid",
        R.img className: "img-circle", src: @props.url
        R.span null, @props.name
      R.div className: "logout container-fluid",
        @imgIcon '/images/logout_icon.png'
        R.button
          className: "logout-button"
          @t("profile.logout")

)

module.exports = ProfileBox

