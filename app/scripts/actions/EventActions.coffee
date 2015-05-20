
EventFactory      = require '../factories/EventFactory'
PlannerDispatcher = require '../dispatcher/PlannerDispatcher'
{ActionTypes}     = require '../constants/PlannerConstants'
{saveSchedule}    = require './ScheduleActions'


class EventActions

  @addEvent: (name, startDt, endDt, days, repeatUntil, color)->
    event = EventFactory.create
      name: name
      startDt: startDt
      endDt: endDt
      color: color
      recurrence:
        daysOfWeek: days
        repeatUntil: repeatUntil
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.ADD_EVENT
      event: event
    saveSchedule()

  @updateEvent: (eventId, startDt, endDt, dayDelta)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.UPDATE_EVENT
      event:
        id: eventId
        startDt: startDt
        endDt: endDt
        dayDelta: dayDelta
    saveSchedule()

  @changeEventColor: (eventId, color)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.CHANGE_EVENT_COLOR
      eventId: eventId
      color: color
    saveSchedule()

  @removeEvent: (eventId)->
    PlannerDispatcher.dispatchViewAction
      type: ActionTypes.REMOVE_EVENT
      eventId: eventId
    saveSchedule()


module.exports = EventActions
