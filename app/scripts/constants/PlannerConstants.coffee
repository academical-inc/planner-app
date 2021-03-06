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

module.exports =
  UiConstants: require './UiConstants'
  PayloadSources: {
    "SERVER_ACTION"
    "VIEW_ACTION"
  }
  ActionTypes: {
    "INIT_SCHOOL"
    "LOGIN_USER"
    "LOGOUT_USER"
    "FETCH_USER"
    "FETCH_USER_SUCCESS"
    "FETCH_USER_FAIL"
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
    "GET_SCHEDULE"
    "GET_SCHEDULE_SUCCESS"
    "GET_SCHEDULE_FAIL"
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
    "EXPORT_IMAGE"
    "EXPORT_IMAGE_SUCCESS"
    "EXPORT_ICS"
    "EXPORT_ICS_SUCCESS"
    "EXPORT_ICS_FAIL"
    "SEARCH"
    "SEARCH_SUCCESS"
    "SEARCH_FAIL"
    "CLEAR_SEARCH"
    "TOGGLE_FILTER"
    "MAX_SCHEDULES_FAIL"
    "TOGGLE_SCHEDULE_LIST"
    "TOGGLE_OPTIONS_MENU"
  }
  PreviewTypes: {
    "PRIMARY"
    "SECONDARY"
  }
  CalendarDates: {
    "TERM_START"
    "TERM_END"
  }
  WeekCalendarCommands: {
    PREV: 'prev'
    TODAY: 'today'
    NEXT: 'next'
    GOTO_DATE: 'gotoDate'
  }
  DebounceRates: {  # milliseconds
    SAVE_RATE: 1000
    SEARCH_RATE: 150
  }
  Pages: {
    "LANDING"
    "APP"
    "SINGLE_SCHEDULE"
    "ERROR"
  }
  RouterConstants: {
    REDIRECT_STORAGE: "academical:redirect-request"
  }
  AuthConstants: {
    TOKEN_STORAGE: "academical:auth0-token"
    USER_STORAGE: "academical:user"
    AUTH0_SCOPE: "openid name email picture app_metadata"
    TOKEN_EXPIRTATION: 540  # 9 hours in minutes
    TOKEN_EXPIRATION_MS: 32400000  # 9 hours in milliseconds
    AUTH0_ISSUER: "academical.auth0.com"
    Providers: {
      WAAD: "waad"
    }
  }
  GoogleApiConstants: {
    API_HOST: "https://www.googleapis.com"
  }
  ShareConstants: {
    FB_SHARE_URL: "https://www.facebook.com/dialog/share"
    TW_SHARE_URL: "https://twitter.com/intent/tweet"
  }
  POLL_INTERVAL: 120000  # milliseconds
  MAX_SCHEDULE_NAME_LENGTH: 23
  MAX_SCHEDULES: 7
  MAX_EVENT_NAME_LENGTH: 23
