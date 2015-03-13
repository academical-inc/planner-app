
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
_                 = require '../utils/HelperUtils'


class ChildStoreHelper

  constructor: (@store, @collection, @elementsMap={}, @currentElements=[])->

  initElementsMap: (schedules)->
    schedules.forEach (schedule)=>
      @updateSchedule schedule

  setCurrent: (scheduleId=@store.current().id)->
    @currentElements = @elementsMap[scheduleId]

  addSchedule: (scheduleId)->
    @elementsMap[scheduleId] = []

  updateSchedule: (schedule)->
    @elementsMap[schedule.id] = schedule[@collection] or []

  removeSchedule: (scheduleId)->
    delete @elementsMap[scheduleId]

  addElement: (element)->
    @currentElements.push element

  removeElement: (elementId)->
    _.findAndRemove @currentElements, (el)-> el.id == elementId

  wait: ->
    PlannerDispatcher.waitFor [@store.dispatchToken]


module.exports = ChildStoreHelper
