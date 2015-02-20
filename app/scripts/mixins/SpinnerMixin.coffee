
React = require 'react'
R     = React.DOM


module.exports =

  renderSpinner: (type="spinner", anim="spin")->
    R.i className: "fa fa-#{type} fa-#{anim}"

