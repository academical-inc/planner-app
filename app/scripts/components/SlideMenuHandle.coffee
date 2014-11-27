
$         = require 'jquery'
React     = require 'react/addons'
selectors = require('../constants/PlannerConstants').selectors
R         = React.DOM

SlideMenuHandle = React.createClass(

  handleClick: (e)->
    $(selectors.SCHEDULE_LIST).trigger "open.mm"

  render: ->
    classes = React.addons.classSet({
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
