
ids =
  SCHEDULE_LIST: 'pla-schedule-list'
  PERSONAL_EVENT_MODAL: 'pla-personal-event-modal'
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
    PERSONAL_EVENT_MODAL: "##{ids.PERSONAL_EVENT_MODAL}"
    ERROR_MODAL: "##{ids.ERROR_MODAL}"
  htmlEntities:
    TIMES: "\u00d7"
  sectionSeatsMap:
    UPPER: bound: 20, className: "success"
    LOWER: bound: 10, className: "warning"
    ZERO:  className: "danger"
  dropdown:
    MAX_INPUT_LENGTH: 28
  defaultSectionColor: "#2daae1"
  defaultPevColor: "#6db533"
  days: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
  colors: [
    "#f27979"
    "#f2a979"
    "#f2da79"
    "#daf279"
    "#a9f279"
    "#79f279"
    "#79f2a9"
    "#79f2da"
    "#79daf2"
    "#79a9f2"
    "#7979f2"
    "#a979f2"
    "#da79f2"
    "#f279da"
    "#f279a9"
  ]

