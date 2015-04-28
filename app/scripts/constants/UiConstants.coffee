
ids =
  SCHEDULE_LIST: 'pla-schedule-list'
  EVENT_MODAL: 'pla-event-modal'
  ERROR_MODAL: 'pla-error-modal'
  SEARCH_FILTERS: 'pla-search-filters'

module.exports =
  media:
    SCREEN_XS_MIN: 1
    SCREEN_SM_MIN: 768
    SCREEN_MD_MIN: 992
    SCREEN_LG_MIN: 1200
  ids: ids
  selectors:
    SCHEDULE_LIST: "##{ids.SCHEDULE_LIST}"
    EVENT_MODAL: "##{ids.EVENT_MODAL}"
    ERROR_MODAL: "##{ids.ERROR_MODAL}"
    SEARCH_FILTERS: "##{ids.SEARCH_FILTERS}"
  htmlEntities:
    TIMES: "\u00d7"
  sectionSeatsMap:
    UPPER: bound: 20, className: "success"
    LOWER: bound: 10, className: "warning"
    ZERO:  className: "danger"
  dropdown:
    MAX_INPUT_LENGTH: 28
  defaultSectionColor: "#2daae1"
  defaultEventColor: "#6db533"
  days: ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
  colors: [
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
  search:
    minLen: 1
    maxResults: 30

