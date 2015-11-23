
$             = require 'jquery'
React         = require 'react'
Classnames    = require 'classnames'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

SlideMenuHandle = React.createClass(

  handleClick: (e)->
    $(UiConstants.selectors.SCHEDULE_LIST).trigger "open.mm"

  render: ->
    classes = Classnames({
      'pla-slide-menu-handle'
      'hidden-md'
      'hidden-lg'
      'fa'
      'fa-th-list'
      'fa-2x'
    })
    R.i className: classes, onClick: @handleClick

)

module.exports = SlideMenuHandle
