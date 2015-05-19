
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
