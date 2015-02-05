
H          = require '../../SpecHelper'
Resource   = require '../../../app/scripts/api/Resource'
Academical = require '../../../app/scripts/api/Academical'


describe 'Resource', ->

  describe "#constructor", ->

    beforeEach ->
      @api = new Academical {}

      @basePath        = @api.get "basePath"
      @urlInterpolator = H.spy("urlInterpolator").and.callFake (path)-> path
      @restore         = H.rewire Resource,
        "Url.makeUrlInterpolator": @urlInterpolator

    afterEach ->
      @restore()

    it 'inits base path correctly', ->
      res = new Resource @api
      expect(@urlInterpolator).toHaveBeenCalledWith @basePath
      expect(res.basePath).toEqual @basePath

    it 'inits path correctly when provided', ->
      class Res1 extends Resource
        path: "resources"

      res = new Res1 @api
      expect(@urlInterpolator.calls.mostRecent().args[0]).toEqual "resources"
      expect(res.path).toEqual "resources"

    it 'inits path correctly when not provided', ->
      res = new Resource @api
      expect(@urlInterpolator.calls.count()).toEqual 1
      expect(res.path).toEqual ""


  describe '._responseParser', ->

    it 'returns tha correct parser for json data', ->
      response = data: {f1: 1, f2: 2}, success: true
      cb       = H.spy "cb"
      parser   = Resource._responseParser cb
      parser response
      expect(cb).toHaveBeenCalledWith(f1: 1, f2: 2)


  describe '._formatRequestData', ->

    beforeEach ->
      @reqData = f1: 1, f2: 2

    it 'wraps request data with "data" key when method is not "get"', ->
      result  = Resource._formatRequestData "post", @reqData
      expect(result).toEqual data: @reqData

    it 'returns data as is when method is "get"', ->
      result  = Resource._formatRequestData "get", @reqData
      expect(result).toEqual @reqData


  xdescribe '@createApiCall', ->

    beforeEach ->
      @api = new Academical {}
      @res = new Resource @api

      callSpec =
        method: "get"
        path: "call/path/{p1}"
        requiredParams: ["p1"]
      @res.call = Resource.createApiCall callSpec

    it "creates correct api call when", ->

