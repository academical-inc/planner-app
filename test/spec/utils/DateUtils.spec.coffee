
H         = require '../../SpecHelper'
DateUtils = require '../../../app/scripts/utils/DateUtils'

describe "DateUtils", ->

  beforeEach ->
    @restore = H.rewire DateUtils,\
      UiConstants:
        days: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

  afterEach ->
    @restore()

  describe '.getDayForDate', ->

    it 'returns the correct day string for the given date', ->
      date = new Date 2015, 1, 1 # Sunday
      expect(DateUtils.getDayForDate(date)).toEqual "Su"

      date = new Date 2015, 1, 2 # Monday
      expect(DateUtils.getDayForDate(date)).toEqual "Mo"

      date = new Date 2015, 1, 6 # Friday
      expect(DateUtils.getDayForDate(date)).toEqual "Fr"
