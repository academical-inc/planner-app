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

React        = require 'react'
R            = React.DOM


ErrorFooter = React.createClass(

  render: ->
    R.section className: 'pla-error-footer hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default navbar-fixed-bottom",
          R.div className: "container-fluid"

)

module.exports = ErrorFooter
