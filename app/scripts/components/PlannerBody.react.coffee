
React             = require 'react'
WeekCalendar      = require './WeekCalendar.react'
SectionSearchPane = require './SectionSearchPane.react'
R                 = React.DOM


PlannerBody = React.createClass(

  render: ->
    R.div className: 'container-fluid',
      R.div className: 'row',
        R.div className: 'col-md-3',
          SectionSearchPane({})
        R.div className: 'col-md-9',
          WeekCalendar({})

)

module.exports = PlannerBody


