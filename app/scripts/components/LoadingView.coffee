
React     = require 'react'
IconMixin = require '../mixins/IconMixin'
R         = React.DOM


LoadingView = React.createClass(

  mixins: [IconMixin]

  render: ->
    R.div className: 'pla-loading-view',
      R.span className: "vertical-align-helper"
      @renderSpinner()

)

module.exports = LoadingView
