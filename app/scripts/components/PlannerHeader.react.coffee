
React        = require 'react'
ScheduleList = require './ScheduleList.react'
ProfileBox   = require './ProfileBox.react'
R            = React.DOM


PlannerHeader = React.createClass(

  render: ->
    R.div className: 'container-fluid',
      R.div className: 'row',
        R.div className: 'col-md-3',
          R.span null, "Logo Here"
        R.div className: 'col-md-6',
          ScheduleList({})
        R.div className: 'col-md-3',
          ProfileBox({})

)

module.exports = PlannerHeader

