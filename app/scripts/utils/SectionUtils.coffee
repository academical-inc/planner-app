
SchoolStore   = require '../stores/SchoolStore'
_             = require '../utils/Utils'
I18n          = require '../utils/I18n'
{UiConstants} = require '../constants/PlannerConstants'


class SectionUtils

  @fieldFor: (key)->
    @fields ?= SchoolStore.school().appUi.infoFields
    @fields[key]

  @department: (section)->
    # TODO Need to make this more flexible. Only working for our 2 current
    # schools
    depInfo = @fieldFor("department")
    arr     = _.getNested section, depInfo.list
    if arr.length > 0
      arr[0][depInfo.field]
    else
      I18n.t "section.noDepartment"

  @teacherNames: (section)->
    if section.teacherNames.length > 0
      section.teacherNames.join ", "
    else
      I18n.t "section.noTeacher"

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
