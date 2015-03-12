
H           = require '../../SpecHelper'
DataHelpers = require '../../../app/scripts/api/DataHelpers'


describe 'DataHelpers', ->

  describe '.newEvent', ->

    it 'returns correct event with recurrence if specified', ->
      ev = DataHelpers.newEvent(
        "Ev"
        "2015-01-01T10:35:00+00:00"
        "2015-01-01T10:55:00+00:00"
        "America/Bogota"
        days: ["MO", "TU"]
        to: "2015-05-01T10:35:00+00:00"
      )
      expect(ev).toEqual
        name: "Ev"
        startDt: "2015-01-01T10:35:00+00:00"
        endDt: "2015-01-01T10:55:00+00:00"
        timezone: "America/Bogota"
        recurrence:
          daysOfWeek: ["MO", "TU"]
          freq: "WEEKLY"
          repeatUntil: "2015-05-01T10:35:00+00:00"

    it 'returns correct event with recurrence if specified', ->
      ev = DataHelpers.newEvent(
        "Ev"
        "2015-01-01T10:35:00+00:00"
        "2015-01-01T10:55:00+00:00"
        "America/Bogota"
      )
      expect(ev).toEqual
        name: "Ev"
        startDt: "2015-01-01T10:35:00+00:00"
        endDt: "2015-01-01T10:55:00+00:00"
        timezone: "America/Bogota"

    it 'throws error if provided days are not valid', ->
      f = ->
        DataHelpers.newEvent(
          "Ev"
          "2015-01-01T10:35:00+00:00"
          "2015-01-01T10:55:00+00:00"
          "America/Bogota"
          days: ["Mon", "Tue"]
          to: "2015-05-01T10:35:00+00:00"
        )
      expect(f).toThrowError()
