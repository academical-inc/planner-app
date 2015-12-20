
React        = require 'react'
_            = require '../utils/Utils'
I18nMixin    = require '../mixins/I18nMixin'
SectionUtils = require '../utils/SectionUtils'
SchoolStore  = require '../stores/SchoolStore'
AppActions   = require '../actions/AppActions'
R            = React.DOM


ResultItem = React.createClass(

  mixins: [I18nMixin]

  fieldFor: SectionUtils.fieldFor

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
    school       = SchoolStore.school().nickname
    section      = @props.section
    colorClass   = SectionUtils.seatsColorClass section
    teacherNames = SectionUtils.teacherNames(section)
    department   = SectionUtils.department(section)

    R.div
      className: 'pla-result-item'
      R.div null,
        @highlight section.sectionId
        R.span null, " "
        @highlight section.courseCode
        R.span null, ' - ' + @t("section.sectionNumber.#{school}", {
          number: section.sectionNumber
        })
      R.div null,
        @highlight section.courseName
      R.div null,
        @highlight department
        R.span className: "label label-#{colorClass}",
          @t(
            "section.seats.#{school}"
            seats: _.getNested section, @fieldFor("seats")
          )
      R.div null,
        @highlight teacherNames

)

module.exports = ResultItem
