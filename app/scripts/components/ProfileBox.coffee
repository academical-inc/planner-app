
React       = require 'react'
I18nMixin   = require '../mixins/I18nMixin'
IconMixin   = require '../mixins/IconMixin'
Dropdown    = React.createFactory require './Dropdown'
OptionsItem = React.createFactory require './OptionsItem'
R           = React.DOM

ProfileBox = React.createClass(

  mixins: [I18nMixin, IconMixin]

  profile: ->
    R.div null,
      R.span null, @props.name
      R.img src: @props.url

  getItems: ->
    [
      {id: "logout", val: @t("profile.logout"), icon: @icon "sign-out"}
    ]

  render: ->
    Dropdown(
      className: 'pla-profile-box'
      rootTag: @props.rootTag
      title: @profile()
      itemType: OptionsItem
      items: @getItems()
    )

)

module.exports = ProfileBox

