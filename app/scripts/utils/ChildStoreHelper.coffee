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

PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
_                 = require '../utils/Utils'


class ChildStoreHelper

  constructor: (@store, @collection, @elementsMap={}, @currentElements=[])->

  initElementsMap: (schedules)->
    schedules.forEach (schedule)=>
      @updateSchedule schedule

  setCurrent: (scheduleId=@store.current().id)->
    @currentElements = @elementsFor scheduleId

  updateSchedule: (schedule)->
    els = if Array.isArray(schedule[@collection])
      schedule[@collection].filter (el)-> Object.keys(el).length > 0
    else
      schedule[@collection]
    @setElements schedule.id, els

  removeSchedule: (scheduleId)->
    delete @elementsMap[scheduleId]

  addElement: (element)->
    @currentElements.push element

  removeElement: (elementId, test=->true)->
    [el, i] = @findElement elementId
    if test el, i
      _.removeAt @currentElements, i

  findElement: (elementId)->
    _.findWithIdx @currentElements, (el)-> el.id == elementId

  setElements: (scheduleId, elements=[])->
    @elementsMap[scheduleId] = elements

  elementsFor: (scheduleId)->
    @elementsMap[scheduleId]

  currentElementsOr: (id)->
    if id?
      @elementsFor id
    else
      @currentElements

  wait: (stores=[])->
    PlannerDispatcher.waitFor [@store.dispatchToken].concat stores


module.exports = ChildStoreHelper
