
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

    it 'sets the time to the moment object correctly when using strings', ->
      time = "2014-01-20T10:30:00.000-05:00"
      date = "2015-05-09"

      expect(DateUtils.setTime(date, time).hours()).toEqual 10
      expect(DateUtils.setTime(date, time).minutes()).toEqual 30

    it 'sets the time to the moment object correctly when using moments', ->
      time = Moment "2014-01-20T10:30:00.000-05:00"
      date = Moment "2015-05-09"

      expect(DateUtils.setTime(date, time).hours()).toEqual 10
      expect(DateUtils.setTime(date, time).minutes()).toEqual 30

    it 'sets the time to the moment object correctly when using combination', ->
      time = "2014-01-20T10:30:00.000-05:00"
      date = Moment "2015-05-09"

      expect(DateUtils.setTime(date, time).hours()).toEqual 10
      expect(DateUtils.setTime(date, time).minutes()).toEqual 30


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
