

module.exports =
  UiConstants: require './UiConstants'
  PayloadSources: {
    "SERVER_ACTION"
    "VIEW_ACTION"
  }
  ActionTypes: {
    "OPEN_SCHEDULE"
    "GET_SCHEDULES"
    "GET_SCHEDULES_SUCCESS"
    "GET_SCHEDULES_FAIL"
    "UPDATE_SCHEDULES"
    "UPDATE_SCHEDULES_SUCCESS"
    "UPDATE_SCHEDULES_FAIL"
    "CREATE_SCHEDULE"
    "CREATE_SCHEDULE_SUCCESS"
    "CREATE_SCHEDULE_FAIL"
    "DELETE_SCHEDULE"
    "DELETE_SCHEDULE_SUCCESS"
    "DELETE_SCHEDULE_FAIL"
    "UPDATE_SCHEDULE_NAME"
    "SAVE_SCHEDULE"
    "SAVE_SCHEDULE_SUCCESS"
    "SAVE_SCHEDULE_FAIL"
    "ADD_SECTION"
    "REMOVE_SECTION"
    "CHANGE_SECTION_COLOR"
    "ADD_SECTION_PREVIEW"
    "REMOVE_SECTION_PREVIEW"
    "OPEN_EVENT_FORM"
    "ADD_EVENT"
    "UPDATE_EVENT"
    "REMOVE_EVENT"
    "CHANGE_EVENT_COLOR"
    "SET_WEEK"
    "OPEN_SUMMARY_DIALOG"
  }
  PreviewTypes: {
    "PRIMARY"
    "SECONDARY"
  }
  WeekCalendarCommands: {
    PREV: 'prev'
    TODAY: 'today'
    NEXT: 'next'
  }
  POLL_INTERVAL: 120000  # milliseconds
