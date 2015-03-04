
DAYS = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]

class DataHelpers

  @newSchedule: (name, studentId, schoolId, term)->
    name:       name
    studentId:  studentId
    schoolId:   schoolId
    term:       term

  @newPersonalEvent: (name, startDt, endDt, timezone, days, to, {location, \
      description, color}={})->

    days = days.map (day)->
      d = day.toUpperCase()
      if not (d in DAYS)
        throw new Error "Academical: Event days must be one of #{DAYS}"
      d

    ev =
      name:      name
      startDt:   startDt
      endDt:     endDt
      timezone:  timezone
      recurrence:
        daysOfWeek: days
        freq: "WEEKLY"
        repeatUntil: to
    ev.location    = location if location?
    ev.description = description if description?
    ev.color       = color if color?
    ev


module.exports = DataHelpers
