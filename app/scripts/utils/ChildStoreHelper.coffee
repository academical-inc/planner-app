
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
