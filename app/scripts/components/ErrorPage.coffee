
React       = require 'react'
PlainHeader = React.createFactory require './PlainHeader'
PlainFooter = React.createFactory require './PlainFooter'
I18nMixin   = require '../mixins/I18nMixin'
R           = React.DOM


ErrorPage = React.createClass(

  mixins: [I18nMixin]

  render: ->
    statusCode = @props.error.statusCode
    errorMessage = @props.error.message

    R.div className: 'pla-content container-fluid',
      PlainHeader({})
      R.div className: 'pla-error-page',
        R.span className: 'helper'
        R.div className: 'error-content',
          R.div className: 'error-image',
            R.img src: "/images/error_icon.png"
          R.div className: 'error-text-box',
            R.span className: 'code', statusCode
            R.span className: 'message',
              @t errorMessage
            R.a
              className: 'btn btn-default error-button'
              href:'/'
              role: 'button'
              @t "errors.backHome"
      PlainFooter({})

)

module.exports = ErrorPage
