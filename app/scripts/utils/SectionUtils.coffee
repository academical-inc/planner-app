
SchoolStore   = require '../stores/SchoolStore'
{UiConstants} = require '../constants/PlannerConstants'


class SectionUtils

  @seatsColorClass: (section, school=SchoolStore.school().nickname)->
    # TODO Make this not hardcoded
    seatsMap = UiConstants.sectionSeatsMap
    if section.seats.available >= seatsMap.UPPER.bound
      if school is "cesa"
        seatsMap.ZERO.className
      else
        seatsMap.UPPER.className
    else if section.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      if school is "cesa"
        seatsMap.UPPER.className
      else
        seatsMap.ZERO.className


module.exports = SectionUtils
