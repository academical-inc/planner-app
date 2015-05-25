
React          = require 'react'
_              = require '../utils/HelperUtils'
I18nMixin      = require '../mixins/I18nMixin'
SectionUtils   = require '../utils/SectionUtils'
PlannerActions = require '../actions/PlannerActions'
R              = React.DOM


ResultItem = React.createClass(

  mixins: [I18nMixin]

  getDefaultProps: ->
    query: ""

  highlight: (text, query=@props.query)->
    qLen = query.length
    if qLen > 0 and not @props.focused
      re   = new RegExp _.escapeRegexCharacters(query), 'gi'
      idxs = _.findAllRegexMatches re, text
      cur  = 0
      args = [null]

      idxs.forEach (idx)->
        reg  = text[cur...idx]
        bold = text[idx...idx+qLen]
        args.push reg if reg
        args.push R.strong(null, bold) if bold
        cur = idx + qLen

      last = text[cur...]
      args.push last

      R.span.apply null, args
    else
      R.span null, text

  # TODO Test
  render: ->
    section = @props.section
    colorClass = SectionUtils.seatsColorClass section
    teacherNames = if section.teacherNames.length > 0
      section.teacherNames.join ", "
    else
      @t "section.noTeacher"
    department = if section.departments.length > 0
      section.departments[0].name
    else
      @t "section.noDepartment"

    R.div
      className: 'pla-result-item'
      R.div null,
        @highlight section.sectionId
        R.span null, " "
        @highlight section.courseCode
      R.div null,
        @highlight section.courseName
      R.div null,
        @highlight department
        R.span className: "label label-#{colorClass}",
          @t "section.seats", seats: section.seats.available
      R.div null,
        @highlight teacherNames

)

module.exports = ResultItem
