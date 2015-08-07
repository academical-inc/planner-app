
H            = require '../../SpecHelper'
SectionUtils = require '../../../app/scripts/utils/SectionUtils'


describe 'SectionUtils', ->

  describe '#seatsColorClass', ->

    seats = (seats)->
      seats: available: seats

    beforeEach ->
      @restore = H.rewire SectionUtils,
        UiConstants:
          sectionSeatsMap:
            UPPER: bound: 50, className: "upper"
            LOWER: bound: 15, className: "lower"
            ZERO:  className: "zero"

    afterEach ->
      @restore()

    it 'returns correct css class when seats available is >= upper bound ', ->
      sec = seats 50
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "upper"

      sec = seats 60
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "upper"

    it 'returns correct css class when seats available is < upper bound and
        >= lower bound', ->
      sec = seats 15
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "lower"

      sec = seats 20
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "lower"

    it 'returns correct css class when seats available is < lower bound ', ->
      sec = seats 14
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "zero"

      sec = seats 0
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "zero"

      sec = seats -3
      expect(SectionUtils.seatsColorClass(sec, "uniandes")).toEqual "zero"

