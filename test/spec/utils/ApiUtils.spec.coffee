
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
      _: @_
      Academical: H.spy "s1", retVal: @api
      "_api": @api
      "_hostname": "school.host.com"
      "_currentStudent": id: "stud1"
      "_currentSchool":
        id: "school1"
        terms: @terms
        timezone: "America/Bogota"

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
      ApiUtils.data.newEvent "Name", "2015", "2016", ["Mo"]
      expect(@api.data.newEvent).toHaveBeenCalledWith(
        "Name"
        "2015"
        "2016"
        "America/Bogota"
        ["Mo"]
        @terms[0].endDate
        location: undefined
        description: undefined
        color: undefined
      )
