
React = require 'react/addons'
R     = React.DOM

S     = require('../constants/PlannerConstants').selectors

SlideMenuHandle = React.createClass(

  handleClick: (e)->
    $(S.SCHEDULE_LIST).trigger "open.mm"

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
