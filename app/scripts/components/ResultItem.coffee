
React     = require 'react'
_         = require '../utils/HelperUtils'
I18nMixin = require '../mixins/I18nMixin'
R         = React.DOM


ResultItem = React.createClass(

  mixins: [I18nMixin]

  highlight: (text, query=@props.query)->
    qLen = query.length
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

  render: ->
    section = @props.section
    query   = @props.query

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
      R.div null,
        @highlight teacherNames

)

module.exports = ResultItem
