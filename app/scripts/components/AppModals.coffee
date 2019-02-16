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

React         = require 'react'
I18nMixin     = require '../mixins/I18nMixin'
EventForm     = React.createFactory require './EventForm'
SummaryDialog = React.createFactory require './SummaryDialog'
ShareDialog   = React.createFactory require './ShareDialog'
ErrorDialog   = React.createFactory require './ErrorDialog'
R             = React.DOM

AppModals = React.createClass(

  mixins: [I18nMixin]

  render: ->
    ui = @props.ui

    R.div className: "pla-app-modals",
      EventForm({})
      SummaryDialog fields: ui.summaryFields
      ShareDialog({})
      ErrorDialog({})

)

module.exports = AppModals
