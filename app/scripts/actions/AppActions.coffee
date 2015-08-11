
$               = require 'jquery'
SchoolActions   = require './SchoolActions'
AuthActions     = require './AuthActions'
ScheduleActions = require './ScheduleActions'
SectionActions  = require './SectionActions'
EventActions    = require './EventActions'
WeekActions     = require './WeekActions'
ModalActions    = require './ModalActions'
ExportActions   = require './ExportActions'
SearchActions   = require './SearchActions'
UiActions       = require './UiActions'


# TODO Test All Actions
module.exports = $.extend(
  {},
  SchoolActions
  AuthActions
  ScheduleActions
  SectionActions
  EventActions
  WeekActions
  ModalActions
  ExportActions
  SearchActions
  UiActions
)
