
H           = require '../../SpecHelper'
DataHelpers = require '../../../app/scripts/api/DataHelpers'


describe 'DataHelpers', ->

  describe '.newEvent', ->

    it 'returns correct event', ->
      ev = DataHelpers.newEvent(
        "Ev"
        "2015-01-01T10:35:00-05:00"
        "2015-01-01T10:55:00-05:00"
        "America/Bogota"
        ["MO", "TU"]
        "2015-05-01T10:35:00-05:00"
      )
      expect(ev).toEqual
        name: "Ev"
        startDt: "2015-01-01T10:35:00-05:00"
        endDt: "2015-01-01T10:55:00-05:00"
        timezone: "America/Bogota"
        recurrence:
          daysOfWeek: ["MO", "TU"]
          freq: "WEEKLY"
          repeatUntil: "2015-05-01T10:35:00-05:00"

    it 'throws error if provided days are not valid', ->
      f = ->
        DataHelpers.newEvent(
          "Ev"
          "2015-01-01T10:35:00-05:00"
          "2015-01-01T10:55:00-05:00"
          "America/Bogota"
          ["Mon", "Tue"]
          "2015-05-01T10:35:00-05:00"
        )
      expect(f).toThrowError()
