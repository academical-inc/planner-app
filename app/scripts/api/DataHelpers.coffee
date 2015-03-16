
DAYS = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]

class DataHelpers

  @scheduleToUpdate: (name, credits, sections, events)->
    name: name
    totalCredits: credits
    totalSections: sections.length
    events: events
    sectionIds: sections.map (sec)-> sec.id

  @newSchedule: (name, studentId, schoolId, term)->
    name:       name
    studentId:  studentId
    schoolId:   schoolId
    term:       term

  @newEvent: (name, startDt, endDt, timezone, {days, to, location, \
      description, color}={})->

    recurrence = if days? and to?
      days.forEach (day)->
        if not (day in DAYS)
          throw new Error "Academical: Event days must be one of #{DAYS}"
      daysOfWeek: days
      freq: "WEEKLY"
      repeatUntil: to

    ev =
      name:      name
      startDt:   startDt
      endDt:     endDt
      timezone:  timezone

    ev.recurrence  = recurrence if recurrence?
    ev.location    = location if location?
    ev.description = description if description?
    ev.color       = color if color?
    ev


module.exports = DataHelpers
