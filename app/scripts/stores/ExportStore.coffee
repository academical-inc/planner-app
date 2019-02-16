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

Store         = require './Store'
ScheduleStore = require './ScheduleStore'
ExportUtils   = require '../utils/ExportUtils'
{ActionTypes} = require '../constants/PlannerConstants'


# TODO Test
class ExportStore extends Store


  dispatchCallback: (payload)->
    action = payload.action

    # TODO Revisit this design, not very Flux-y
    # Chose this because don't want to keep entire canvas data just hanging in
    # memory, so prefer to perfomr download immediatly instead of keeping as
    # private var inside this store
    # See OptionsMenu TODO
    switch action.type
      when ActionTypes.EXPORT_IMAGE_SUCCESS
        ExportUtils.downloadImage ScheduleStore.current().name, action.canvas
      when ActionTypes.EXPORT_ICS_SUCCESS
        ExportUtils.downloadICS ScheduleStore.current().name, action.icsData


module.exports = new ExportStore
