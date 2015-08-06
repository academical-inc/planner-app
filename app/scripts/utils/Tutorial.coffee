
$             = require 'jquery'
React         = require 'react'
Tour          = require 'bootstrap-tour'
Env           = require '../Env'
I18n          = require '../utils/I18n'
ScheduleStore = require '../stores/ScheduleStore'
SearchStore   = require '../stores/SearchStore'
PreviewStore  = require '../stores/PreviewStore'
SectionStore  = require '../stores/SectionStore'
AppActions    = require '../actions/AppActions'
R             = React.DOM

# Private
# TODO Test and Clean Up a bit. Code looks super dirty
renderTemplate = ({nextTxt, nextBtn}={})->
  nextTxt ?= I18n.t("tutorial.next")
  nextBtn ?= true

  (step, options)->
    nextRole = if step is 8
      'end'
    else if nextBtn
      'next'
    btns = [
      R.button className: 'btn btn-success', "data-role": nextRole, nextTxt
    ]
    if step > 0 and step < 8
      btns.unshift(
        R.button
          className: 'btn btn-danger'
          "data-role": 'end'
          I18n.t("tutorial.finish")
      )

    el = R.div className: "popover tour pla-tutorial step-#{step}",
      R.div className: "arrow"
      R.div className: "tutorial-header modal-header",
        R.button className: "close", "data-role": "end",
          R.img src: '/images/popup_quit_icon.png'
          R.span className: "sr-only", "Close"
        R.h4 className: "modal-title popover-title"
      R.div className: "popover-content"
      R.div className: "tutorial-footer modal-footer popover-navigation",
        btns
    React.renderToString(el)

renderContent = (content)->
  el = R.div null,
    content.map (txt, i)->
      R.div className: "tutorial-text", key: i,
        R.p null, txt
  React.renderToString el

goToResults = ->
  if SearchStore.results().length > 0
    Tutorial.goTo 4

goToSections = ->
  if SectionStore.sections().length is 1
    Tutorial.goTo 5

hideResults = ->
  Tutorial.hide 4

_tutorial = new Tour
  container: '.pla-content'
  storage: false if Env.APP_ENV is "development"
  template: renderTemplate()
  onEnd: ->
    ScheduleStore.removeChangeListener Tutorial.start
    SearchStore.removeChangeListener goToResults
    PreviewStore.removeChangeListener hideResults
    SectionStore.removeChangeListener goToSections
    return
  steps: [
    {
      orphan: true
      template: renderTemplate nextTxt: I18n.t("tutorial.start")
      title: I18n.t "tutorial.welcome.header"
      content: renderContent I18n.t("tutorial.welcome.content")
    }
    {
      reflex: true
      animation: false
      element: '.pla-schedule-item:first-child'
      title: I18n.t "tutorial.schedules.header"
      content: renderContent I18n.t("tutorial.schedules.content")
      onShow: ->
        AppActions.toggleScheduleList()
      onNext: ->
        AppActions.toggleScheduleList()
    }
    {
      reflex: true
      animation: false
      element: '.pla-options-item:first-child'
      title: I18n.t "tutorial.options.header"
      content: renderContent I18n.t("tutorial.options.content")
      onShow: ->
        AppActions.toggleOptionsMenu()
      onNext: ->
        AppActions.toggleOptionsMenu()
    }
    {
      reflex: true
      animation: false
      element: '.pla-search-filters-trigger'
      template: renderTemplate nextBtn: false, nextTxt: I18n.t("dialogs.ok")
      title: I18n.t "tutorial.search.header"
      content: renderContent I18n.t("tutorial.search.content")
      onShown: ->
        $('.search-input>input').focus()
        $('.pla-tutorial.step-3 .btn-success').on 'click', -> Tutorial.hide()
    }
    {
      reflex: true
      animation: false
      element: '.result:first-child'
      template: renderTemplate nextBtn: false, nextTxt: I18n.t("dialogs.ok")
      title: I18n.t "tutorial.results.header"
      content: renderContent I18n.t("tutorial.results.content")
      onShown: ->
        $('.pla-tutorial.step-4 .btn-success').on 'click', -> Tutorial.hide()
    }
    {
      reflex: true
      animation: false
      element: '.pla-section-list .panel-group'
      title: I18n.t "tutorial.sections.header"
      content: renderContent I18n.t("tutorial.sections.content")
      onShown: ->
        $('.pla-section-item:first-child .collapse').collapse 'toggle'
    }
    {
      reflex: true
      animation: false
      element: '.pla-event-list .add-item-bar span'
      title: I18n.t "tutorial.events.header"
      content: renderContent I18n.t("tutorial.events.content")
    }
    {
      reflex: true
      animation: false
      placement: 'bottom'
      element: '.pla-week-control'
      title: I18n.t "tutorial.calendar.header"
      content: renderContent I18n.t("tutorial.calendar.content")
    }
    {
      orphan: true
      template: renderTemplate nextTxt: I18n.t("tutorial.finish")
      title: I18n.t "tutorial.end.header"
      content: renderContent I18n.t("tutorial.end.content")
    }
  ]

class Tutorial

  @init: ->
    _tutorial.init()
    ScheduleStore.addChangeListener @start
    SearchStore.addChangeListener goToResults
    PreviewStore.addChangeListener hideResults
    SectionStore.addChangeListener goToSections

  @goTo: (step)->
    _tutorial.goTo step

  @hide: (step)->
    selector = '.pla-tutorial'
    selector += ".step-#{step}" if step?
    $(selector).popover("hide")

  @start: =>
    if ScheduleStore.all().length > 0
      _tutorial.start()
      ScheduleStore.removeChangeListener @start


module.exports = Tutorial
