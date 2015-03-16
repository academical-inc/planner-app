
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
    @setElements schedule.id, schedule[@collection]

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

  setElements: (scheduleId, elements)->
    @elementsMap[scheduleId] = elements or []

  elementsFor: (scheduleId)->
    @elementsMap[scheduleId]

  wait: ->
    PlannerDispatcher.waitFor [@store.dispatchToken]


module.exports = ChildStoreHelper