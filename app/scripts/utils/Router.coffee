
Page                     = require 'page'
React                    = require 'react'
I18n                     = require './I18n'
{RouterConstants, Pages} = require '../constants/PlannerConstants'
NavError                 = require '../errors/NavError'
NavErrorStore            = require '../stores/NavErrorStore'
AuthErrorStore           = require '../stores/AuthErrorStore'
UserStore                = require '../stores/UserStore'
Lscache                  = require 'lscache'

render = (component)->
  React.render component, document.body

getRedirectRequest = ->
    Lscache.get RouterConstants.REDIRECT_STORAGE

# TODO Test
class Router

  @init: ->
    NavErrorStore.addChangeListener =>
      @goTo Pages.ERROR, code: NavErrorStore.code(), msg: NavErrorStore.msg()
    AuthErrorStore.addChangeListener =>
      @goTo Pages.LANDING, error: AuthErrorStore.msg()

  @goTo: (page, props={})->
    LandingPage   = React.createFactory require '../components/LandingPage'
    SchedulePage  = React.createFactory require '../components/SchedulePage'
    AppPage       = React.createFactory require '../components/AppPage'
    ErrorPage     = React.createFactory require '../components/ErrorPage'

    switch page
      when Pages.LANDING
        render LandingPage props
      when Pages.APP
        render AppPage props
      when Pages.SINGLE_SCHEDULE
        render SchedulePage props
      when Pages.ERROR
        render ErrorPage props

  @redirect: (path, force = false)->
    if !force
      Page.redirect path
    else
      window.location.href = path

  @createRedirectRequest: (path) ->
    expirationTime = 5 # Minutes
    Lscache.set RouterConstants.REDIRECT_STORAGE,
                { redirectPath: path }, expirationTime

  @cleanRedirectRequests: ->
    Lscache.remove RouterConstants.REDIRECT_STORAGE

  @executeRedirectRequests: ->
    redirectRequest = getRedirectRequest()
    if !!redirectRequest
      @cleanRedirectRequests()
      @redirect redirectRequest.redirectPath

  @defRoute: (path, cb)->
    Page path, cb

  @route: ->
    @defRoute '*', =>
      @goTo Pages.ERROR, code: 404, msg: I18n.t "errors.notFound"

    Page()


module.exports = Router
