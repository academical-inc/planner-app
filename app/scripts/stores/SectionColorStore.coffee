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

Store            = require './Store'
ScheduleStore    = require './ScheduleStore'
ChildStoreHelper = require '../utils/ChildStoreHelper'
{ActionTypes}    = require '../constants/PlannerConstants'


# Private
_ = new ChildStoreHelper(ScheduleStore, 'sectionColors')


# TODO Revisit this design
# TODO Tests
class SectionColorStore extends Store

  colors: (id)->
    _.currentElementsOr id

  dispatchCallback: (payload)=>
    action = payload.action

    switch action.type
      when ActionTypes.OPEN_SCHEDULE
        _.wait()
        _.setCurrent()
      when ActionTypes.GET_SCHEDULES_SUCCESS
        _.wait()
        _.initElementsMap action.schedules
        _.setCurrent()
      when ActionTypes.CREATE_SCHEDULE_SUCCESS
        _.wait()
        _.updateSchedule action.schedule
        _.setCurrent()
      when ActionTypes.DELETE_SCHEDULE_SUCCESS
        _.wait()
        _.removeSchedule action.scheduleId
        _.setCurrent()
      when ActionTypes.ADD_SECTION
        _.currentElements[action.section.id] = action.color
      when ActionTypes.REMOVE_SECTION
        delete _.currentElements[action.sectionId]
      when ActionTypes.CHANGE_SECTION_COLOR
        _.currentElements[action.sectionId] = action.color
        @emitChange()


module.exports = new SectionColorStore
