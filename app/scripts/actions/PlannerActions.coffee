
$               = require 'jquery'
ScheduleActions = require './ScheduleActions'
SectionActions  = require './SectionActions'
EventActions    = require './EventActions'
WeekActions     = require './WeekActions'
ModalActions    = require './ModalActions'
ExportActions   = require './ExportActions'


# # TODO Test All Actions
module.exports = $.extend(
  {},
  ScheduleActions
  SectionActions
  EventActions
  WeekActions
  ModalActions
  ExportActions
)
