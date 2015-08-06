
$             = require 'jquery'
React         = require 'react'
Classnames    = require 'classnames'
{UiConstants} = require '../constants/PlannerConstants'
R             = React.DOM

SlideMenuHandle = React.createClass(

  handleClick: (e)->
    $(UiConstants.selectors.SCHEDULE_LIST).data("mmenu").open()

  render: ->
    classes = Classnames({
      'fa'
      'fa-th-list'
      'fa-2x'
    })
    R.div
      className: 'pla-slide-menu-handle hidden-md hidden-lg',
      onClick: @handleClick
      R.i className: classes

)

module.exports = SlideMenuHandle
