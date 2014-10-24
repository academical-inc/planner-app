
React = require 'react/addons'
R = React.DOM

SlideMenuHandle = React.createClass(

  getDOMHandle: ->
    @getDOMNode()

  render: ->
    classes = React.addons.classSet({
      'pla-slide-menu-handle'
      'hidden-md'
      'hidden-lg'
      'fa'
      'fa-th-list'
      'fa-2x'
    })
    R.i className: classes

)

module.exports = SlideMenuHandle
