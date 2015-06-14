
Page          = require 'page'
React         = require 'react'
I18n          = require './I18n'
{Pages}       = require '../constants/PlannerConstants'
NavError      = require '../errors/NavError'
NavErrorStore = require '../stores/NavErrorStore'
LandingPage   = React.createFactory require '../components/LandingPage'
SchedulePage  = React.createFactory require '../components/SchedulePage'
AppPage       = React.createFactory require '../components/AppPage'
ErrorPage     = React.createFactory require '../components/ErrorPage'

render = (component)->
  React.render component, document.body

# TODO Test
class Router

  @init: ->
    NavErrorStore.addChangeListener =>
      @goTo Pages.ERROR, code: NavErrorStore.code(), msg: NavErrorStore.msg()

  @goTo: (page, props={})->
    switch page
      when Pages.LANDING
        render LandingPage props
      when Pages.APP
        render AppPage props
      when Pages.SINGLE_SCHEDULE
        render SchedulePage props
      when Pages.ERROR
        render ErrorPage props

  @defRoute: (path, cb)->
    Page path, cb

  @route: ->
    @defRoute '*', =>
      @goTo Pages.ERROR, code: 404, msg: I18n.t "errors.notFound"
    Page()


module.exports = Router
