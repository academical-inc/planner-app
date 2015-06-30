
ids =
  SCHEDULE_LIST: 'pla-schedule-list'
  SEARCH_FILTERS: 'pla-search-filters'
  WEEK_CALENDAR: 'pla-week-calendar'
  LOGIN_MODAL: 'pla-login-modal'
  EVENT_MODAL: 'pla-event-modal'
  SUMMARY_MODAL: 'pla-summary-modal'
  SHARE_MODAL: 'pla-share-modal'
  ERROR_MODAL: 'pla-error-modal'

module.exports =
  media:
    SCREEN_XS_MIN: 1
    SCREEN_SM_MIN: 768
    SCREEN_MD_MIN: 992
    SCREEN_LG_MIN: 1200
  ids: ids
  selectors:
    SCHEDULE_LIST: "##{ids.SCHEDULE_LIST}"
    SEARCH_FILTERS: "##{ids.SEARCH_FILTERS}"
    WEEK_CALENDAR: "##{ids.WEEK_CALENDAR}"
    LOGIN_MODAL: "##{ids.LOGIN_MODAL}"
    EVENT_MODAL: "##{ids.EVENT_MODAL}"
    SUMMARY_MODAL: "##{ids.SUMMARY_MODAL}"
    SHARE_MODAL: "##{ids.SHARE_MODAL}"
    ERROR_MODAL: "##{ids.ERROR_MODAL}"
  htmlEntities:
    TIMES: "\u00d7"
  sectionSeatsMap:
    UPPER: bound: 20, className: "success"
    LOWER: bound: 10, className: "warning"
    ZERO:  className: "danger"
  search:
    MIN_LEN: 2
    MAX_RESULTS: 30
  keys:
    ENTER: 13
    ESC: 27
    UP: 38
    DOWN: 40
  site:
    ABOUT: "//academical.co/about"
    CONTACT: "//academical.co/contact"
    PRIVACY: "//academical.co/privacy"
  share:
    MAC_COPY: "⌘ - C"
    PC_COPY: "Ctrl - C"
  DAYS: ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
  COLORS: [
    "#2daae1"
    "#ea4e59"
    "#6db533"
    "#ffd501"
    "#f39200"
    "#074456"
    "#b02de1"
    "#4e76ea"
    "#f57005"
    "#b7b7b7"
    "#ef1616"
    "#9fde25"
  ]
  DEFAULT_SECTION_COLOR: "#2daae1"
  DEFAULT_EVENT_COLOR: "#6db533"
  PROFILE_PLACEHOLDER: "//placehold.it/50x50"
