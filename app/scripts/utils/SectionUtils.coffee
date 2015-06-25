
{UiConstants} = require '../constants/PlannerConstants'


class SectionUtils

  @seatsColorClass: (section)->
    seatsMap = UiConstants.sectionSeatsMap
    if section.seats.available >= seatsMap.UPPER.bound
      seatsMap.UPPER.className
    else if section.seats.available >= seatsMap.LOWER.bound
      seatsMap.LOWER.className
    else
      seatsMap.ZERO.className


module.exports = SectionUtils
