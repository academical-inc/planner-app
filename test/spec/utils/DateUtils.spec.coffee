
Moment    = require 'moment'
H         = require '../../SpecHelper'
DateUtils = require '../../../app/scripts/utils/DateUtils'


describe "DateUtils", ->

  beforeEach ->
    @restore = H.rewire DateUtils,\
      UiConstants:
        days: ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]

  afterEach ->
    @restore()

  describe 'inUtcOffset', ->

    it 'returns date in specified utcOffset when specifying a moment', ->
      date = Moment.parseZone "2015-03-10T08:00:00-05:00"
      offset = -60

      res = DateUtils.inUtcOffset date, offset
      expect(res.utcOffset()).toEqual offset
      expect(res.year()).toEqual 2015
      expect(res.month()).toEqual 2
      expect(res.date()).toEqual 10
      expect(res.hours()).toEqual 8
      expect(res.minutes()).toEqual 0
      expect(res.seconds()).toEqual 0
      expect(res.milliseconds()).toEqual 0

    it 'returns date in specified utcOffset when specifying an iso string', ->
      date = "2015-03-10T08:00:00-04:00"
      offset = -60

      res = DateUtils.inUtcOffset date, offset
      expect(res.utcOffset()).toEqual offset
      expect(res.year()).toEqual 2015
      expect(res.month()).toEqual 2
      expect(res.date()).toEqual 10
      expect(res.hours()).toEqual 8
      expect(res.minutes()).toEqual 0
      expect(res.seconds()).toEqual 0
      expect(res.milliseconds()).toEqual 0


  describe '.getDayStr', ->

    it 'returns the correct day string for the given day', ->
      expect(DateUtils.getDayStr(0)).toEqual "SU"
      expect(DateUtils.getDayStr(1)).toEqual "MO"
      expect(DateUtils.getDayStr(5)).toEqual "FR"


  describe '.getTimeStr', ->

    beforeEach ->
      @t1 = Moment().hours(11).minutes(30).seconds(20)
      @t2 = Moment().hours(15).minutes(50).seconds(20)

    it 'returns the time in the correct format', ->
      res = DateUtils.getTimeStr @t1
      expect(res).toEqual "11:30am"
      res = DateUtils.getTimeStr @t2
      expect(res).toEqual "3:50pm"

    it 'returns the time with provided format', ->
      res = DateUtils.getTimeStr @t1, "HH:mm"
      expect(res).toEqual "11:30"
      res = DateUtils.getTimeStr @t2, "HH:mm"
      expect(res).toEqual "15:50"


  describe '.getTimeFromStr', ->

    it 'returns correct utc moment obj from time str in default format', ->
      res = DateUtils.getTimeFromStr "11:30am"
      expect(res.hours()).toEqual 11
      expect(res.minutes()).toEqual 30
      expect(res.isUTC()).toBe true
      res = DateUtils.getTimeFromStr "3:50pm"
      expect(res.hours()).toEqual 15
      expect(res.minutes()).toEqual 50
      expect(res.isUTC()).toBe true

    it 'returns correct utc moment obj from time str in provided format', ->
      res = DateUtils.getTimeFromStr "11:30", "HH:mm"
      expect(res.hours()).toEqual 11
      expect(res.minutes()).toEqual 30
      expect(res.isUTC()).toBe true
      res = DateUtils.getTimeFromStr "15:50", "HH:mm"
      expect(res.hours()).toEqual 15
      expect(res.minutes()).toEqual 50
      expect(res.isUTC()).toBe true

  describe '.setTime', ->

    assertDate = (res, year, month, date, hours, minutes, offset)->
      expect(res.year()).toEqual year
      expect(res.month()).toEqual month
      expect(res.date()).toEqual date
      expect(res.hours()).toEqual hours
      expect(res.minutes()).toEqual minutes
      expect(res.utcOffset()).toEqual offset

    it 'sets the time to the moment object correctly when using strings', ->
      time = "2014-01-20T10:30:00.000-04:00"
      date = "2015-05-09"

      res = DateUtils.setTime(date, time, -300)
      assertDate res, 2015, 4, 9, 10, 30, -300

    it 'sets the time to the moment object correctly when using moments', ->
      time = Moment.parseZone "2014-01-20T10:30:00.000-05:00"
      date = Moment.utc "2015-05-09", "YYYY-MM-DD"

      res = DateUtils.setTime(date, time, -300)
      assertDate res, 2015, 4, 9, 10, 30, -300

    it 'sets the time to the moment object correctly when using combination', ->
      time = "2014-01-20T10:30:00.000-04:00"
      date = Moment.utc "2015-05-09", "YYYY-MM-DD"

      res = DateUtils.setTime(date, time, -240)
      assertDate res, 2015, 4, 9, 10, 30, -240


  describe '.format', ->

    it 'uses default iso format when no format provided', ->
      str = "2014-01-20T10:30:00-05:00"
      date = Moment str

      expect(DateUtils.format(str)).toEqual str
      expect(DateUtils.format(date)).toEqual str

    it 'uses default iso format when no format', ->
      str = "2014-01-20T10:30:00.000-05:00"
      date = Moment str
      expected = "2014-01-20"

      expect(DateUtils.format(str, "YYYY-MM-DD")).toEqual expected
      expect(DateUtils.format(date, "YYYY-MM-DD")).toEqual expected
