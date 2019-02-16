#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
