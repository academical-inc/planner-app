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

_             = require '../utils/Utils'
Store         = require './Store'
SectionStore  = require './SectionStore'
SchoolStore   = require './SchoolStore'
{ActionTypes} = require '../constants/PlannerConstants'


fields = ->
  fds = SchoolStore.school().appUi.summaryFields
  fds.map (f)->
    if typeof f.field is 'string'
      _.camelized f.field
    else
      f.field


# TODO Tests
class SummaryDialogStore extends Store

  summary: ->
    fds      = fields()
    sections = SectionStore.sections()

    sections.map (section)->
      fds.map (f)->
        if f.list?
          val = _.getNested section, _.camelized(f.list)
          res = val.map (el)-> el[f.field]
          res.join ", "
        else
          val = _.getNested section, f
          if Array.isArray val
            val.join ", "
          else
            val

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SUMMARY_DIALOG
        @emitChange()


module.exports = new SummaryDialogStore
