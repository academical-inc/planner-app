
React       = require 'react'
ErrorHeader = React.createFactory require './ErrorHeader'
ErrorFooter = React.createFactory require './ErrorFooter'
I18nMixin   = require '../mixins/I18nMixin'
R           = React.DOM


ErrorPage = React.createClass(

  mixins: [I18nMixin]

  render: ->
    code = @props.code
    msg  = @props.msg
    if Array.isArray msg
      msg = msg.map (er, i)-> R.p(key: "errLine-#{i}", er)

    R.div className: 'pla-content container-fluid',
      ErrorHeader({})
      R.div className: 'pla-error-page',
        R.span className: 'helper'
        R.div className: 'error-content',
          R.div className: 'error-image',
            R.img src: "/images/error_icon.png"
          R.div className: 'error-text-box',
            R.span className: 'code', code
            R.span className: 'message', msg
            R.a
              className: 'btn btn-default error-button'
              href:'/'
              role: 'button'
              @t "errors.backHome"
      ErrorFooter({})

)

module.exports = ErrorPage
