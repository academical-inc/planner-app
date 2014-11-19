
React    = require 'react'
Dropdown = React.createFactory require './Dropdown'
R        = React.DOM

OptionsList = React.createClass(

  render: ->
    R.div className: 'pla-options-list',
      Dropdown({})

)

module.exports = OptionsList

