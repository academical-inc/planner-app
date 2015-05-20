
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
