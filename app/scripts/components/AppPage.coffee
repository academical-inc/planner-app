
React           = require 'react'
AppBody         = React.createFactory require './AppBody'
SlideMenuHandle = React.createFactory require './SlideMenuHandle'
AppModals       = React.createFactory require './AppModals'
AppHeader       = React.createFactory require './AppHeader'
R               = React.DOM

AppPage = React.createClass(

  render: ->
    R.div className: 'pla-content container-fluid',
      SlideMenuHandle({})
      AppHeader({})
      AppBody ui: @props.ui
      AppModals ui: @props.ui

)

module.exports = AppPage
