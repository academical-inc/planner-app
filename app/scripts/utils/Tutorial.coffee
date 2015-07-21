
Lscache         = require 'lscache'
Shepherd        = require 'tether-shepherd'
ScheduleStore   = require '../stores/ScheduleStore'

# Private
_tour = null

class Tutorial

  @init: ->
    _tour = new Shepherd.Tour
      defaults:
        classes: 'shepherd-theme-arrows'
    @addSteps()
    ScheduleStore.addChangeListener @start

  @addSteps: ->
    _tour.addStep "step1",
      text: "It works!"
      attachTo: ".pla-logo-box"
      showCancelLink: true
      buttons: [
        text: 'Next'
        action: _tour.next
      ]
    _tour.addStep "step2",
      text: "Second"
      attachTo: ".pla-week-control"
      showCancelLink: true
      buttons: [
        text: 'Next'
        action: _tour.next
      ]

  @start: =>
    if ScheduleStore.all().length > 0
      _tour.start()
      ScheduleStore.removeChangeListener @start


module.exports = Tutorial
