
Moment   = require 'moment'
H        = require '../../SpecHelper'
ApiUtils = require '../../../app/scripts/utils/ApiUtils'


describe 'ApiUtils', ->

  beforeEach ->
    @api = H.spyObj "s2", ["setHost", "data"]
    @_   = H.spyObj "_",
      setTime: (a1,a2)->a1
      format: (a1)->a1
      utc: (a1)->a1
    @terms = [{startDate: "2015-01-01", endDate: "2015-05-01"}]
    @global = H.rewire ApiUtils,
      "Env.API_HOST": "API_HOST"
      "Env.API_PROTOCOL": "API_PROTOCOL"
      Academical: H.spy "s1", retVal: @api
      "_api": @api
      "_hostname": "school.host.com"
      "_currentStudent": id: "stud1"
      "_currentSchool":
        id: "school1"
        terms: @terms
        timezone: "America/Bogota"
        utcOffset: -300

  afterEach ->
    @global()

  describe '.init', ->

    it 'inits correctly', ->
      ApiUtils.init()
      expect(@api.setHost).toHaveBeenCalledWith "API_HOST", "API_PROTOCOL"
      expect(ApiUtils.__get__("_currentSchoolNickname")).toEqual "school"


  describe '.data.newSchedule', ->

    it 'creates new schedule correctly', ->
      @api.data.newSchedule = H.spy "s3"
      ApiUtils.data.newSchedule "Name"
      expect(@api.data.newSchedule).toHaveBeenCalledWith(
        "Name"
        "stud1"
        "school1"
        @terms[0]
      )


  describe '.data.newEvent', ->

    it 'creates new event correctly', ->
      @api.data.newEvent = H.spy "s3"
      start = Moment.parseZone "2015-03-10T10:00:00-05:00"
      end = Moment.parseZone "2015-03-10T11:00:00-05:00"
      ApiUtils.data.newEvent "Name", start, end, ["Mo"]
      expect(@api.data.newEvent).toHaveBeenCalledWith(
        "Name"
        "2015-03-10T15:00:00+00:00"
        "2015-03-10T16:00:00+00:00"
        "America/Bogota"
        days: ["Mo"]
        to: "2015-05-01T15:00:00+00:00"
        location: undefined
        description: undefined
        color: undefined
      )
