#
# Copyright (C) 2012-2019 Academical Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
