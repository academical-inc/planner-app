
React          = require 'react'
I18nMixin      = require '../mixins/I18nMixin'
LogoBox        = React.createFactory require './LogoBox'
PlannerActions = require '../actions/PlannerActions'
R              = React.DOM


SharePageHeader = React.createClass(

  mixins: [I18nMixin]

  handleClick: ->
    PlannerActions.duplicateSchedule()

  render: ->
    R.section className: 'pla-share-header hidden-xs hidden-sm',
      R.nav className: "navbar navbar-default", role: "navigation",
        R.div className: "container-fluid",
          R.ul className: "nav navbar-nav pla-logo",
            LogoBox({})
          R.ul className: "nav navbar-nav",
            R.li null,
              R.span className: 'helper', null
              R.div className: 'pla-share-button',
                R.button
                  className: 'btn btn-default'
                  onClick: @handleClick
                  R.img src: '/images/add_schedule_icon.png'
                  R.span null, @t "duplicateSchedule"

)

module.exports = SharePageHeader

