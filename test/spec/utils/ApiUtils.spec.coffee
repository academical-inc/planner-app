
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
      Academical: H.spy "s1", retVal: @api
      "_api": @api
      "_currentStudent": id: "stud1"

  afterEach ->
    @global()

  describe '.init', ->

    it 'inits correctly', ->
      ApiUtils.init()
      expect(@api.setHost).toHaveBeenCalledWith "API_HOST"
